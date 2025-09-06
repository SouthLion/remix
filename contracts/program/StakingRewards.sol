// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract StakingRewards {
    IERC20 public immutable stakingToken;     // 质押token
    IERC20 public immutable rewardsToken;     // 奖励token

    address public owner;   // 管理员（设置奖励时长和奖励的截止时间）

    uint256 public duration;    // 奖励时长，（单位为秒）
    uint256 public finishAt;    // 奖励截止时间
    uint256 public updatedAt;   // 合约的更新时间
    uint256 public rewardRate;  // 奖励的速率，每秒钟能拿到多少奖励token
    uint256 public rewardPerTokenStored;    // 指的是全局每个质押token的奖励token数量, rewardPerTokenStored =  （rewardRate * duration） / 总质押量

    mapping(address => uint256) public userRewardPerTokenPaid;  // 每一个用户的已经领取了多少奖励
    mapping(address => uint256) public rewards; // 记录每个用户当前获得的奖励

    uint256 public totalSupply; // 合约内总共的质押代币数量
    mapping(address => uint256) public balanceOf;   // 每一个用户质押的代币数量

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();
        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;
    }

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    // 管理员可以设置奖励的持续时间，只有在当前奖励期结束后才允许更新。
    function setRewardsDuration(uint256 _duration) external onlyOwner {
        require(finishAt < block.timestamp, "reward duration not finished");
        duration = _duration;
    }

    // 管理员设置奖励金额的时候，我们就能通过时长取计算出我们的reward rate
    // 管理员调用此函数来通知奖励代币总数量，并且根据持续时间计算奖励速率（rewardRate）
    // 该函数首先检查奖励是否可用，并确保合约中有足够的奖励代币余额。
    function notifyRewardAmount(uint256 _amount)
        external
        onlyOwner
        updateReward(address(0))
    {
        // 奖励持续时间还没开始或者已经过期了
        if (block.timestamp > finishAt) {
            rewardRate = _amount / duration;
        } else {
            // 如果奖励期没有结束，则需要计算“剩余奖励”，即当前奖励期剩余时间内的所有奖励
            uint256 remainingRewards = rewardRate *
                (finishAt - block.timestamp);

            // 每秒钟奖励多少 rewardsToken
            rewardRate = (remainingRewards + _amount) / duration;
        }
        require(rewardRate > 0, "reward rate = 0");
        require(
            // 检查当前合约能不能发出这么多奖励
            rewardRate * duration <= rewardsToken.balanceOf(address(this)),
            "reward amount > balance"
        );
        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    // 用户调用此函数来质押代币。质押的代币转入合约，
    function stake(uint256 _amount) external updateReward(msg.sender) {
        require(_amount > 0, "amount = 0");
        // 质押代币转移到合约里
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        // 用户质押的金额
        balanceOf[msg.sender] += _amount;
        // 整个合约质押代币的数量
        totalSupply += _amount;
    }

    // 用户调用此函数来提取质押的代币。balanceOf[msg.sender] 和 totalSupply 会相应减少。
    function withdraw(uint256 _amount) external updateReward(msg.sender) {
        require(_amount > 0, "amount = 0");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    // 该函数最终返回当前奖励期的有效截止时间，具体来说，就是当前时间与奖励结束时间中的较小值。
    // 如果当前时间早于奖励结束时间：返回当前时间 block.timestamp，表示奖励仍然有效，可以继续计算奖励。
    // 如果当前时间已经超过奖励结束时间：返回 finishAt，表示奖励已经结束，无法再继续计算新的奖 
    function lastTimeRewardApplicable() public view returns (uint256) {
        return _min(block.timestamp, finishAt);
    }

    // 计算并返回每个代币的奖励金额。它基于奖励速率和已过的时间动态更新
    function rewardPerToken() public view returns (uint256) {
        /*
            如果 totalSupply == 0，那么 rewardPerToken() 就直接返回 rewardPerTokenStored，
            即之前记录的全局每个代币的奖励值。因为在没有质押代币的情况下，不需要重新计算奖励，直接返回之前的存储值。
        */
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            ((rewardRate * (lastTimeRewardApplicable() - updatedAt)) * 1e18) /
            totalSupply;
    }

    // 返回指定账户累计的奖励金额
    function earned(address _account) public view returns (uint256) {
        return
            (balanceOf[_account] *
                (rewardPerToken() - userRewardPerTokenPaid[_account])) /
            1e18 +
            rewards[_account];
    }

    // 用户调用此函数来提取奖励。合约会根据 rewards 映射中的值向用户转账奖励
    function getReward() external updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.transfer(msg.sender, reward);
        }
    }

    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }
}

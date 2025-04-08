// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DiscreteStakingRewards {
    IERC20 public immutable stakingToken; // 质押代币（如ETH、DAI）
    IERC20 public immutable rewardToken; // 奖励代币（如项目方代币）

    mapping(address => uint256) public balanceOf; // 用户质押的代币余额
    uint256 public totalSupply; // 总质押量

    uint256 private constant MULTIPLIER = 1e18; // 精度放大因子（防止浮点误差）
    uint256 private rewardIndex; // 全局奖励指数（动态计算）
    mapping(address => uint256) private rewardIndexOf; // 用户上次的奖励指数快照
    mapping(address => uint256) private earned; // 用户已累积未领取的奖励

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    /*
        功能：外部调用者（如项目方）向合约转入奖励代币，并根据当前总质押量更新奖励指数。

        逻辑：

        每注入一次奖励，全局奖励指数 rewardIndex 增加：
        增量 = (奖励代币数量 * 1e18) / 总质押量

        这相当于将奖励按当前质押比例分配给所有质押者（类似按股份分红）。

    */
    function updateRewardIndex(uint256 reward) external {
        rewardToken.transferFrom(msg.sender, address(this), reward); // 转入奖励代币
        rewardIndex += (reward * MULTIPLIER) / totalSupply; // 更新全局奖励指数
    }

    //  计算用户未领取的奖励
    function _calculateRewards(address account) private view returns (uint256) {
        uint256 shares = balanceOf[account];
        return (shares * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
    }

    function calculateRewardEarned(address account)
        external
        view
        returns (uint256)
    {
        return earned[account] + _calculateRewards(account);
    }

    // 更新用户奖励状态
    function _updateRewards(address account) private {
        earned[account] += _calculateRewards(account); // 累加新奖励到已赚取余额
        rewardIndexOf[account] = rewardIndex; // 更新用户的奖励指数快照
    }

    // 质押代币
    function stake(uint256 amount) external {
        _updateRewards(msg.sender); // 更新奖励
        balanceOf[msg.sender] += amount; // 更新用户质押余额
        totalSupply += amount; // 更新总质押量
        stakingToken.transferFrom(msg.sender, address(this), amount); // 转入质押代币
    }

    // 取消质押
    function unstake(uint256 amount) external {
        _updateRewards(msg.sender);     // 更新奖励
        balanceOf[msg.sender] -= amount;    // 减少用户质押余额
        totalSupply -= amount;  // 减少总质押量
        stakingToken.transfer(msg.sender, amount);  // 转回质押代币
    }

    // 领取奖励
    function claim() external returns (uint256) {
        _updateRewards(msg.sender);     // 更新奖励
        uint256 reward = earned[msg.sender];
        if (reward > 0) {
            earned[msg.sender] = 0;     // 重置已赚取余额
            rewardToken.transfer(msg.sender, reward);   // 转出奖励代币
        }
        return reward;
    }
}

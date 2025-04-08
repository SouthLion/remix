// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IERC20 {
    function transfer(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);
}

contract CrowdFund {
    event Launch(
        uint256 id,
        address indexed creator,
        uint256 goal,
        uint32 startAt,
        uint32 endAt
    );

    event Cancel(uint256 id);
    // 用户对众筹活动进行支持。
    event Pledge(uint256 indexed id, address indexed caller, uint256 amount);
    // 用户撤回部分支持金额
    event Unpledge(uint256 indexed id, address indexed caller, uint256 amount);
    // 发起人领取众筹的资金
    event Claim(uint256 id);
    // 支持者在众筹失败后退款
    event Refund(uint256 indexed id, address indexed caller, uint256 amount);

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;    // 已筹集的金额。 
        uint32 startAt;
        uint32 endAt;
        bool claimed;       // 发起方是否领取金额
    }

    IERC20 public immutable token;
    uint256 public count;       // 有多少个活动现在正在发起中
    mapping(uint256 => Campaign) public campaigns;  // 存储和快速检索众筹活动的详细信息
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;   // 每个众筹项目每个用户参与了多少金额

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(
        uint256 _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");
        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    // 在活动开始之前取消活动。 
    function cancel(uint256 _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp < campaign.startAt, "started");
        delete campaigns[_id];
        emit Cancel(_id);
    }

    //  参与函数
    function pledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);
        emit Pledge(_id, msg.sender, _amount);
    }

    // 取消参与
    function unpledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");
        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        emit Unpledge(_id, msg.sender, _amount);
    }

    // 提取资金
    function claim(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        // 要求现筹集到的资金大于目标资金
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");
        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);
        emit Claim(_id);
    }

    // 筹金活动失败后，退还资金。
    function refund(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged < goal");
        uint256 bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
        emit Refund(_id, msg.sender, bal);
    }
}

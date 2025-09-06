// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorTimelockControl} from "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";

// 治理合约
contract MyGovernor is Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction
{
    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {}

    // 提案冷却期：定义提案创建（propose()）后到投票正式开始之间的延迟时间
    // 目的：给代币持有者预留准备时间，防止闪电提案攻击
    function votingDelay() public pure override returns (uint256) {
        return 2;   
    }

    // 投票持续时间：定义投票开始后的总有效投票时长
    // 目的：确保足够时间让代币持有者参与决策
    // 同样默认以区块数为单位
    function votingPeriod() public pure override returns (uint256) {
        return 2;   
    }
    
    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }
}

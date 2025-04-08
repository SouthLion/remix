// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _nftId
    ) external;
}

contract DutchAuction {
    uint256 private constant DURATION = 7 days;

    IERC721 public immutable nft;

    uint256 public immutable nftId;

    address public immutable seller;    // 卖家地址

    uint256 public immutable startingPrice; // 初始售卖价格

    uint256 public immutable startAt;       // 售卖起始时间

    uint256 public immutable expiresAt; // 售卖结束时间

    uint256 public immutable discountRate;  // 折扣率

    constructor(
        uint256 _startingPrice,
        uint256 _discountRate,
        address _nft,
        uint256 _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        require(
            _startingPrice >= _discountRate * DURATION,
            "starting price < discount"
        );
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "aution expired");
        uint256 price = getPrice();
        require(msg.value >= price, "ETH < price");
        nft.transferFrom(seller, msg.sender, nftId);
        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }
}

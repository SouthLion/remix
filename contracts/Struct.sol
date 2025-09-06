// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Structs {
    struct Car {
        string model;
        uint256 year;
        address owner;
    }
    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function examples() external {
        // 严格按照字段定义顺序
        Car memory toyota = Car("Toyota", 1990, msg.sender);
        // 可以不按照字段定义顺序
        Car memory lambo = Car({
            year: 1980,
            model: "Lamborghini",
            owner: msg.sender
        });

        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        cars.push(Car("Ferrari", 2020, msg.sender));

        // 如果是memory修饰，修改实是在内存上修改的，无法保留在区块链上
        // 当把关键字改为storage时候，状态变量car的数值也会随着_car属性数值一起改变
        Car storage _car = cars[0];
        _car.year = 1999;
        delete _car.owner;      // 变成默认值address（0）
        delete cars[1];     // 把cars中的下标为1的car各个字段都重置为默认值
    }
}

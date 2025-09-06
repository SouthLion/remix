// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// insert, update, read from array of structs
contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({text: _text, completed: false}));
    }

    function updateText(uint256 _index, string calldata _text) external {
        // 更新字段只有一个时，这样写更省gas
        todos[_index].text = _text;

        // 当更新结构体里面的多个字段，这样写更省gas
        // Todo storage todo = todos[_index];
        // todo.text = _text;
    }

    function get(uint256 _index) external view returns (string memory, bool) {
        Todo memory todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // 完成事项
    function toggleCompleted(uint256 _index) external {
        todos[_index].completed = !todos[_index].completed;
    }
}

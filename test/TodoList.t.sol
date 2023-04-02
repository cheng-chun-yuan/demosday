// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TodoList.sol";

contract TodoListTest is Test {
    TodoList public todoList;

    function setUp() public {
        todoList = new TodoList();
    }

    function testAddTodoIntoTodos() public {
        todoList.addTodo("amidoggy");
        assertEq(todoList.getTodo(0),"amidoggy");
    }
    function testDeleteTodo() public {
        todoList.addTodo("amidoggy");
        todoList.deleteTodo(0);
        assertEq(todoList.getTodo(0),"");
    }
}

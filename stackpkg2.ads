-- This is the generic specification for a dynamic stack abstract data type.

generic
    -- Size : Positive;
    -- Size was included in the array implementations
    --      and is not needed here.

	type ItemType is private;

package StackPkg2 is

	type Stack is limited private;

	Stack_Empty, Stack_Full: exception;

	function isEmpty(S: Stack) return Boolean;
	function isFull(S: Stack) return Boolean;

	procedure push(Item: ItemType; S : in out Stack);
	procedure pop(S : in out Stack);

	function top(S: Stack) return ItemType;

private
	type StackNode;

	type Stack is access StackNode;

	type StackNode is record
		Item: ItemType;
		Next: Stack;
	end record;

end StackPkg2;

package main

import "core:fmt"

main :: proc() {
	result: bool = is_bigger_than(1, 2)

	some_variable: int = 7
	if some_variable == 7 {
		fmt.println("its 7")
	}

	if some_variable > 7 {

	} else if 9 == 2 {

	} else {

	}

	if some_variable == 7 {is_bigger_than(1, 2)}
	if some_variable == 7 do is_bigger_than(1, 2)

	/*
	for { 	//while(true)
		fmt.println("Infinite loop")
		if 7 == 3 {
			break
		}
	}
    */
	i: int = 0
	for i < 5 {
		i += 1
	}

	for x: int = 0; x < 10; x += 1 {
		fmt.println(x) //0 - 9
	}

	for i in 0 ..< 10 { 	//0..<10 specifices a range
		fmt.println(i) //i is less than 10
	}

	for i in 0 ..= 10 {
		fmt.println(i) //i is less than or equal to 10
	}

	//break outer loops - label the outer loop
	outer: for x in 0 ..< 20 {
		for y in 0 ..< 20 {
			if y == 3 {
				continue //cotinue can also be used with labels
			}
			if x == 5 && y == 5 {
				break outer
			}
		}
	}

	//array with fixed length
	ten_ints: [10]int = {61, 81, 12, 41, 5, 10, 1234, 8, 4, 1}
	ten_ints = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10} //reassign
	third_item: int = ten_ints[2] //access via index
	ten_ints[6] = 512
	for n in ten_ints {
		fmt.println(n)
	}

	//reverse the loop
	#reverse for l in ten_ints {
		fmt.println(l)
	}

	numbers: [10]int = {6, 4, 7, 10, 1, -1, -9, 100, 1, 54}
	compare: int = 6

	for n in numbers {
		if is_bigger_than(n, compare) {
			fmt.printfln("%v is bigger than %v", n, compare)
		}
	}
}

is_bigger_than :: proc(number: int, compare_to: int) -> bool {
	return number > compare_to
}


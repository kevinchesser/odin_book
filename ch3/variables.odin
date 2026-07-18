package main

import "core:fmt"

main :: proc() {
	number: int
	number = 7
	number_gross := 7 //eww

	fmt.println(number)
	number = 12
	fmt.println(number)

	decimal_number: f32 = 7.42
	decimal_number_gross := f32(7.42)

	CONSTANT_NUMBER :: 12
	number_from_constant: int = CONSTANT_NUMBER

	BIG_CONSTANT_NUMBER :: 100_000_000
	small_number: i8 = BIG_CONSTANT_NUMBER //wont compile i8 = 8 bit signed integer

	DECIMAL_CONSTANT :: 27.12
	my_integer: int = DECIMAL_CONSTANT //wont compile

	DECIMAL_CONSTANT_NODECIMALVALUE :: 7.0
	my_integer_ok: int = DECIMAL_CONSTANT_NODECIMALVALUE // will compile

	CONSTANT_WITH_TYPE: f32 : 7.42

	//signed ints
	//int i8 i16 i32 i64 i128
	//positive and negative whole numbers
	//int could be i64 or i32 depending on pc

	//unsigned ints
	//uint u8 u16 u32 u64 u128 uintpr
	//positive whole numbers (including zero)
	//uint could be i64 or i32 depending on pc
	//uintptr is a special unsigned integer that is always of pointer size

	//floating point number
	//f16 f32 f64
	//positive and negative decimal numbers
	//if a value is too big then it will take on the value positive or negative infinity (??)

	//bolean types
	//bool b8 b16 b32 b64
	//false or true
	//bool is equivalent to b8 - it uses 8 bites, or 1 byte of memory
	//the specific b32 etc variants are mostly for interfacing with other programming languages
	//just use bool

	//strings
	//string
	//text encoded as utf-8
	//cstring for dealing with C

	//runes
	//rune
	//single utf-8 string code point. Mostly a single char but can be a "grapheme cluster"(wtf?)
	//internally a int32

}


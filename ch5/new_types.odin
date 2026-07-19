package main
import "core:fmt"

main :: proc() {
	rect: Rectangle
	rectangle_initialized: Rectangle = {
		width  = 20,
		height = 10,
		//not mentioned x and y get initialized to their zero value
	}
	rectangle_initialized = { 	//assign a new value, effectively re-initialize
		width  = 30,
		height = 25,
		//the non mentioned x and y are zero-initialized again, even if they did have a value
	}

	rect2: Rectangle = {20, 20, 100, 100} //can do this and the values go to the order of the struct. Who would ever do this???

	//size_of(Some_Type) to get size of a type
	p: Person
	fmt.println(size_of(Person))

	p2: Person = {
		//nested initialization of the stats field
		stats = {health = 7},
		name = "Bob",
	}
	//fetch and set with .
	p2.name = "Bobinski"
	p2.stats.age = 200
	bobinskis_health: int = p2.stats.health
	bobinskis_health2: int = p2.health //possible when stats has the using keyword added to it.

	player: Player = {
		id       = 7,
		position = {5, 2},
		can_jump = true,
	}

	fmt.println(player.position)

	print_entity_position(player)

	my_interface: My_Interface = {
		required_name_length = 5,
		is_valid_name        = my_proc,
	}

	comp_type: ComputerType
	comp_type = .Mainframe //don't like this
	comp_type = .Laptop
	comp_type = ComputerType.Mainframe

	switch comp_type {
	case .Laptop:
		fmt.println("It's a laptop")
	case ComputerType.Desktop:
		fmt.println("It's a desktop")
	case .Mainframe:
		fmt.println("It's a mainframe")
	}
	//could do this with ifs but the switch is simpler and usually the compiler generated code is more efficient
	if comp_type == .Laptop {
		fmt.println("It's a laptop")
	} else if comp_type == .Desktop {
		fmt.println("It's a desktop")
	} else if comp_type == .Mainframe {
		fmt.println("It's a mainframe")
	}

	//can make a partial switch that does not cover all members by marking it partial
	#partial switch comp_type {
	case .Laptop:
		fmt.println("It's a laptop")
	case .Desktop:
		fmt.println("It's a desktop")
	}

	val: My_Union = int(12)
	val = Person_Stats {
		health = 100,
		age    = 21,
	}
	fmt.println(size_of(My_Union)) //=24 16 for the data and 8 for the tag which stores what variant is current being held

	//we can use switches on unions as well
	//if we want to make v modifiable within the case then we need a & in from of v.
	switch v in val {
	case int:
	//you can use v, it is of type int
	case f32:
	//you can use v, it is of type f32
	case Person_Stats:
		//you can use v, it is of type Person_Stats. You can use v to access the fields of Person_Stats
		fmt.println(v.age)
	}


	//if we want to make v modifiable within the case then we need a & in from of v.
	//this actually doesn't make it a pointer. It makes it an "addressable"
	switch &v in val {
	case int:
		v = 7
	case f32:
		v = 42
	case Person_Stats:
		v.age = 7
	}

	//to check if a union is holding a specific variant
	f32_val, f32_val_ok := val.(f32)
	if f32_val_ok {
		//f32_val is ok to use in here
	}

	//this is a bit neater and the same thing
	//The part after the ; actually checks the condition.
	//f32_val and f32_val_ok are only available within the if statement.
	if f32_val, f32_val_ok := val.(f32); f32_val_ok {
		//f32_val is ok to use in here
	}

	//if you wish to modify the value
	//in this case the & does make f32_val into a poitner.
	if f32_val, ok := &val.(f32); ok {
		f32_val^ = 7
	}

	// Zero value= nil
	shape: Shape
	//If you add no_nil to the declaration of a union then the zero value will be the first item in the union
	//ex
	//Shape :: union #no_nil {
	//  Shape_Circle
	//  Shape_Square
	//}
	//core:reflect has procedures to get and set the tag of a union


	//Shape at the bottom of this file has three possible tag unions
	//0 -> nil
	//1 -> Shape_Circle
	//2 -> Shape_Square


	//There is a special type called Maybe
	//Variables of Maybe can either have no value, or some value. It's implemented using a union that has a single variant:
	/*
  Maybe :: union($T: typeid) {
    T,
  }
  */
	//So Maybe = Nullable?
	time: Maybe(int)
	fmt.println(time) //nil
	time = 5
	fmt.println(time) //5

	//So now time can be either nil or have a value of type int. Can be checked to see if it has a value
	//time.? syntax is the same as writing time.(int)
	if time_val, time_val_ok := time.?; time_val_ok {
		//use time_val
	}

	t := time.? //will crash if time is nil
	//this odin type of union is known as "tagged unions". Because there is a tagv inside it that keeps track of which variant ic urrently holds

	//C-style unions that have both an enum and a union to keep track of the tag yourself can also be implemented by putting #raw_union on a struct
	My_Raw_Union :: struct #raw_union {
		number:     int,
		struct_val: Person_Stats,
	}
	a_raw_union: My_Raw_Union

	player_entity: Entity_More_Efficient = {
		position = {0, 0},
		texture = Texture{filepath = "asdf.png"},
		variant = Entity_Player{can_jump = true},
	}
}

print_entity_position :: proc(e: Entity) {
	fmt.println(e.position)
}

//define a new type "Rectangle" via struct
Rectangle :: struct {
	x:      f32,
	y:      f32,
	width:  f32,
	height: f32,
}

Person_Stats :: struct {
	health: int,
	age:    int,
}

//struct in a struct
Person :: struct {
	//no separation between the memory of the two. The memory used by the statis field lives directly within the Person struct
	using stats: Person_Stats,
	name:        string,
}

Entity :: struct {
	id:       int,
	position: [2]f32,
}

//can_jump is unique to the player
Player :: struct {
	using entity: Entity,
	can_jump:     bool,
}

//if for example I didn't want any other fields in Player I could define a type alias as
//Player :: Entity


My_Interface :: struct {
	required_name_length: int,
	is_valid_name:        proc(_: My_Interface, _: string) -> bool, //in general not a great thing to do. Just use structs and separate procedures.
}

my_proc :: proc(i: My_Interface, name: string) -> bool {
	return i.required_name_length == len(name)
}

ComputerType :: enum {
	Laptop, //value 0
	Desktop, //value 1
	Mainframe, //value 2
}

asdf :: enum {
	x = 0,
	y = 4,
	q = 21,
}

//by default the backing type for enum is int

//we can change this
Animal_Type :: enum u8 {
	Cat,
	Rabbit,
}
//to compare an enum to an int the enum must be cast to an int. aka int(some_enum)

//Unions
//This means that My_Union can hold a value of any of the three types f32, int, or Person_Stats
//The union storesboth which type it currently holds as well as the actual data for the type
//The differnt possible types such as f32, and Person_Stats are referred to as the variants of the union.
//will onlyuse as much memory as the biggest variant
My_Union :: union {
	f32,
	int,
	Person_Stats,
}

Shape_Square :: struct {
	width: f32,
}

Shape_Circle :: struct {
	radius: f32,
}

Shape :: union {
	Shape_Circle,
	Shape_Square,
}


//position and texture are general but can_jump and time_in_space maybe only be used for certain entities
//we can save space inthe entity struct by moving these things into a union
Entity2 :: struct {
	position:      [2]f32,
	texture:       Texture,
	can_jump:      bool,
	time_in_space: f32,
}

Entity_More_Efficient :: struct {
	position: [2]f32,
	texture:  Texture,
	variant:  Entity_Variant,
}

Texture :: struct {
	filepath: string,
}

Entity_Player :: struct {
	can_jump: bool,
}

Entity_Rocket :: struct {
	time_in_sppace: f32,
}

Entity_Variant :: union {
	Entity_Player,
	Entity_Rocket,
}


//Ranges
// Define a range named "part" containing integers from 1 to 45.
range part = 1..45;
 
//Parameters

// Define an array "part_name" where each element corresponds to a part.
string part_name[part] = ["Plate_with_bow", "curved_slope_2x3","curved_slope_1x3", "curved_slope_2x2",
 "root tile", "slope 2x3", "steering wheel", "Small wheel + Slick tire + Bearing element", "Big wheel + Treaded tire + Bearing element", "Spoiler", "Seat", 
 "Rudder", "Left_Wing", "Right_Wing" ,"Motor", "Flame", "Wheel arch", "Clamp", "Claw", "Roof tile with lattice", "angled plate 1x2_1x4", "brick with screen", 
 "mini handle", "stick with flange", "radiator grille", "plate with angle", "round plate 1x1", "plate 1x1 with holder", "plate 1x2 with holder", "tile 1x2", 
 "angular plate", "plate 1x2 with clamp", "plate 1x2 with 1Knob", "plate 1x2", "Brick 1x2", "Plate 1x2 holder", "Plate 1x2 holder", "Plate 1x4", "Plate 2x2", 
 "Corner Plate", "Brick 2x2", "Plate 2x4", "Plate 2x6", "Plate 2x8", "Plate 2x10"];

// Define an array "cost" where each element represents the cost of a part.
float cost[part] = [2,2,2,2,3,3,3,11,15,3,3,2,1,1,2,1,1.5,1,0.5,0.5,1,1,0.5,0.5,0.5,0.5,0.2,0.2,0.2,0.3,0.3,0.3,0.2,0.2,0.3,0.2,0.2,1,1,1,2,3,4,6,7];

// Define an array "value" where each element represents the value of a part.
float value[part] = [3,4,7,3,3,2,0,10,9,0,1,6,5,5,4,0,4,0,1,0,0,4,0,0,3,0,0,0,0,0,3,0,0,1,2,0,0,2,2,2,2,2,4,5,7];

// Define an array "availability" where each element represents the availability of a part.
float availability[part] = [8,1,2,5,1,1,2,2,2,1,2,2,1,1,1,4,1,1,2,2,2,2,1,1,5,4,6,2,2,3,2,2,1,4,2,2,2,3,4,6,2,5,1,2,1];

// Define a variable to store the total cost.
float total_cost = 0;

//Decision Variables

// Define an array "x" to represent the decision variable for each part.
dvar int+ x[part] ;
 
//Objective Function

// Maximize the total value obtained by summing the product of value and the decision variable for each part.
maximize sum(i in part) (value[i]*x[i]);
 
//Constraints
 
subject to{

// Budget limit: The total cost of selected parts must not exceed 45.
budget_limit:
sum(i in part) (cost[i]*x[i])<=45;

// Availability limit: The number of selected parts must not exceed their availability.
availability_limit:
forall(i in part) x[i]<=availability[i];

// Constraint for selecting the seat part.
seat_limit:
x[11] == 1;

// Constraint for selecting the steering wheel part.
//steeringwheel_limit:
x[7] == 1;

// Constraint for selecting the motor part.
motor_limit:
x[15] == 1;

// Constraint for selecting two parts: wheel, tire, and bearing element. 
wheel_tire_bearing_element_limit:
x[8]+x[9] == 2;

// Constraint for selecting one of two specific parts.
plate:
x[44]+x[45] == 1;
} 
//Postprocessing
 
execute {
  	// Check if the CPLEX optimization status is optimal
    if (cplex.getCplexStatus() == 1) {
        // Print the total distance
        writeln("Total contribution = ", cplex.getObjValue());
        // Print the required number of each part and calculate the total cost.
        for (var i in thisOplModel.part) {
            writeln("Required number of ", i," ",part_name[i], " = ", x[i]);
            total_cost = total_cost + (x[i]*cost[i]);
        }
        // Print the total cost.
        writeln();
        writeln("total_cost_of_Car = ",total_cost);
        
    } else {
        writeln("ERROR: Solution not Found");
    }
}

 
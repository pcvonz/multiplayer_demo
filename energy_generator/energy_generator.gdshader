shader_type canvas_item;

uniform float red;
uniform float green;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r = red;
	COLOR.g = green;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

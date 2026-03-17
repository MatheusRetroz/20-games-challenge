shader_type canvas_item;

// Sei que poderia simplesmente modificar o alpha em modulate, porem tinha criado o shaders para criar uma transição mais elaborada,
//porem resolvi simplificar e como eu montei o sistema de transição baseado no shaders, eu apenas mantive ele.

uniform float value: hint_range(0, 1) = 0.0;
uniform vec4 color: source_color = vec4(vec3(0.1), 1.0);


void fragment() {
	COLOR.rgb = color.rgb;
	COLOR.a = value;
}
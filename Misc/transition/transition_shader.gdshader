shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float dot_radius : hint_range(0.0, 1.0) = 0.1;
uniform float dot_intensity : hint_range(0.0, 10.0) = 5.0;
uniform float line_thickness : hint_range(0.0, 1.0) = 0.02;
uniform float line_intensity : hint_range(0.0, 10.0) = 3.0;
uniform float mix_amount : hint_range(0.0, 1.0) = 1.0; // 0 = line only, 1 = dot only

void fragment() {
    vec2 uv = UV - vec2(0.5); // center origin

    // Glowing dot (radial falloff)
    float dist = length(uv);
    float dot_glow = exp(-pow(dist / dot_radius, 2.0) * dot_intensity);

    // Horizontal glowing line (vertical falloff)
    float line_glow = exp(-pow(uv.y / line_thickness, 2.0) * line_intensity);

    // Blend between line and dot
    float glow = mix(line_glow, dot_glow, mix_amount);

    COLOR = glow_color * glow;
}

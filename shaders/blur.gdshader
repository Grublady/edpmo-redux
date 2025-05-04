shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform int radius : hint_range(1, 16) = 8;
uniform float amount : hint_range(0.0, 10.0) = 1.0;
uniform bool horizontal = false;

// Precomputed Gaussian weights for radius 16, sigma ≈ 8
const float weights[17] = float[](
    0.196482, 0.175713, 0.121703, 0.066143, 0.028532,
    0.009909, 0.002798, 0.000654, 0.000126, 0.000020,
    0.000002, 0.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 0.000000
);

void fragment() {
    vec2 uv = SCREEN_UV;
	vec2 offset;
	if (horizontal) {
		offset = vec2(SCREEN_PIXEL_SIZE.x * amount, 0.0); // horizontal blur
	} else {
		offset = vec2(0.0, SCREEN_PIXEL_SIZE.y * amount); // vertical blur
	}
    vec4 blur = texture(SCREEN_TEXTURE, uv) * weights[0];

    for (int i = 1; i <= radius; i++) {
        float w = weights[i];
        vec2 shift = offset * float(i);
        blur += texture(SCREEN_TEXTURE, uv + shift) * w;
        blur += texture(SCREEN_TEXTURE, uv - shift) * w;
    }

    COLOR = blur;
}

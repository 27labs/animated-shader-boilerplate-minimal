#version 300 es

uniform float uTime;

out vec4 FragmentColor;

void main()
{
	float changingValue = 0.5 + (0.5 * cos(uTime));
	FragmentColor = vec4(0.f,changingValue,1.f,1.f);
}
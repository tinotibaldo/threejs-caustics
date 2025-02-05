precision highp float;
precision highp int;

uniform sampler2D texture;
uniform vec2 delta;
varying vec2 coord;

const float attenuation = 0.593;

void main() {
  /* get vertex info */
  vec4 info = texture2D(texture, coord);

  /* calculate average neighbor height */
  vec2 dx = vec2(delta.x, 0.0);
  vec2 dy = vec2(0.0, delta.y);
  float average = (
    texture2D(texture, coord - dx).r +
    texture2D(texture, coord - dy).r +
    texture2D(texture, coord + dx).r +
    texture2D(texture, coord + dy).r
  ) * 0.25;

  /* change the velocity to move toward the average */
  info.g += (average - info.r) * 2.0;

  /* attenuate the velocity a little so waves do not last forever */
  info.g *= attenuation;

  /* move the vertex along the velocity */
  info.r += info.g;

  /* update the normal */
  vec3 ddx = vec3(delta.x, texture2D(texture, vec2(coord.x + delta.x, coord.y)).r - info.r, 0.0);
  vec3 ddy = vec3(0.0, texture2D(texture, vec2(coord.x, coord.y + delta.y)).r - info.r, delta.y);
  info.ba = normalize(cross(ddy, ddx)).xz;

  gl_FragColor = info;
}

PVector normalizeVector(PVector pForce) //3D normalizer
{
  float magnitude;
  magnitude = moduleVector(pForce);

  pForce.x /= magnitude;
  pForce.y /= magnitude;
  pForce.z /= magnitude;

  return pForce;
}

float moduleVector(PVector _v)
{
  float magnitude;

  magnitude = sqrt(_v.x * _v.x + _v.y * _v.y + _v.z * _v.z);

  return magnitude;
}

boolean isInside(Particle target, voxel voxel) {
  return target.pos.x - target.size.x/2 >= voxel.pos.x - voxel.size.x/2 &&
          target.pos.x + target.size.x/2 <= voxel.pos.x + voxel.size.x/2 &&
          target.pos.y - target.size.y/2 >= voxel.pos.y - voxel.size.y/2 &&
          target.pos.y + target.size.y/2 <= voxel.pos.y + voxel.size.y/2 &&
          target.pos.z - target.size.z/2 >= voxel.pos.z - voxel.size.z/2 &&
          target.pos.z + target.size.z/2 <= voxel.pos.z + voxel.size.z/2;
}

boolean isInside(Particle _target, Player _player) {
  
  return moduleVector(new PVector(_target.pos.x - _player.position.x, _target.pos.y - _player.position.y, _target.pos.z - _player.position.z)) <= _player.hitboxSize;
}

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

char prevKey;

class voxel extends renderer {
  PVector property_voxel = new PVector(0, 0); //The vector stored in the voxel
  PVector rotateShape = new PVector(0, 0, 0);

  voxel(int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c) {
    pos.x = posX;
    pos.y = posY;
    pos.z = posZ;
    size.x = dx;
    size.y = dy;
    size.z = dz;
    property_voxel.x = px;
    property_voxel.y = py;
    property_voxel.z = pz;
    col = c;
  }

  void MoveVoxel()
  {
    if (key == 'w' || key == 'W' || prevKey == 'w' || prevKey == 'W')
    {
      pos.y -= 5;
    }

    if (key == 's' || key == 'S' || prevKey == 's' || prevKey == 'S')
    {
      pos.y += 5;
    }

    if (key == 'd' || key == 'D' || prevKey == 'd' || prevKey == 'D')
    {
      pos.x += 5;
    }

    if (key == 'a' || key == 'A' || prevKey == 'a' || prevKey == 'A')
    {
      pos.x -= 5;
    }
  }

  @Override
    void Draw() {
    push();
    noFill();
    stroke(col);
    translate(pos.x - width / 2, pos.y - height / 2, pos.z);
    rotateX(rotateShape.x);
    rotateY(rotateShape.y);
    rotateZ(rotateShape.z);
    box(size.x, size.y, size.z);
    pop();
  }
}

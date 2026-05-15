char prevKey;
boolean goesUp = false;
boolean goesDown = false;
boolean goesLeft = false;
boolean goesRight = false;
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
    if (goesUp)
    {
      pos.y -= 5;
    }

    if (goesDown)
    {
      pos.y += 5;
    }

    if (goesRight)
    {
      pos.x += 5;
    }

    if (goesLeft)
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

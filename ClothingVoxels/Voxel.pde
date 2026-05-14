class voxel extends renderer {
  PVector property_voxel = new PVector(0, 0); //The vector stored in the voxel

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

  @Override
    void Draw() {
    push();
    noFill();
    stroke(col);
    translate(pos.x - width / 2, pos.y - height / 2, pos.z);
    box(size.x, size.y, size.z);
    pop();
  }
}

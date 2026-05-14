//Voxels + Cloth

voxel v;
void setup(){
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, height/2, 0, 100, 100, 100, -5, 0, 0, color(200));
}

void draw(){
  background(255);
  v.render_voxel();
}

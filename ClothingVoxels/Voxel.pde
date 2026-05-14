class voxel{
  PVector pos_voxel = new PVector(0,0); //Voxel position in 2D
  PVector dim_voxel= new PVector(0,0); //Voxel dimensions
  PVector property_voxel = new PVector(0,0); //The vector stored in the voxel
  color color_voxel;
  
  voxel(int posX, int posY, float dx, float dy, float px, float py, color c){
    pos_voxel.x = posX;
    pos_voxel.y = posY;
    dim_voxel.x = dx;
    dim_voxel.y = dy;
    property_voxel.x = px;
    property_voxel.y = py;
    color_voxel = c;
}

void render_voxel(){
  noFill();
  stroke(color_voxel);
  rectMode(CENTER);
  rect((float)pos_voxel.x, (float)pos_voxel.y, dim_voxel.x, dim_voxel.y);
  box(pos_voxel.x, pos_voxel.y, dim_voxel.x, dim_voxel.y, dim_voxel.z);
}
}

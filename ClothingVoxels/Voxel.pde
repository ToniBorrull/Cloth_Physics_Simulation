class voxel{
  PVector pos_voxel; //Voxel position in 2D
  PVector dim_voxel; //Voxel dimensions
  PVector property_voxel; //The vector stored in the voxel
  color color_voxel;
  
  voxel(int posX, int posY, float dx, float dy, float px, float py, color c){
    pos_voxel[0] = posX;
    pos_voxel[1] = posY;
    dim_voxel[0] = dx;
    dim_voxel[1] = dy;
    property_voxel[0] = px;
    property_voxel[1] = py;
    color_voxel = c;
}

void render_voxel(){
  noFill();
  stroke(color_voxel);
  rectMode(CENTER);
  rect((float)pos_voxel[0], (float)pos_voxel[1], dim_voxel[0], dim_voxel[1]);
}
}

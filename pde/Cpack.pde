class Cpack {

  //variables
  float[] rad, srad;
  float cx, cy;
  int icen;
  PVector vcen, vcur, vnex;
  PVector[] vlist;

  //def variables
  Cpack(float[] r, float x, float y){
    rad = r;
    cx = x;
    cy = y;
  }

  PVector[] centros(){
  //Settings
  ellipseMode(RADIUS); stroke(255); noFill(); strokeWeight(0);
  int n = 1; int count = 0; boolean toca = false; icen = 0;
  PVector[] vlist = new PVector[rad.length];

  //Primer y segundo circulos
  vcen = new PVector(cx,cy);
  vcur = new PVector(cx,cy+rad[0]+rad[1]);
  vlist[0] = new PVector(cx,cy);
  vlist[1] = new PVector(cx,cy+rad[0]+rad[1]);

  //Encontrando otros circulos
  while (n < rad.length-1 && count < 1000) {
    count = count+1;
    n = n+1;
    //println("vez"+n,icen);
    //radios de los circulos
    float rcen = rad[icen];
    float rcur = rad[n-1];
    float rnex = rad[n];
    //println(rcen,rcur,rnex);

    //largos de los lados del triangulo
    float a = rcen + rcur;
    float b = rcen + rnex;
    float c = rcur + rnex;

    //calcular angulo
    float ang = acos(((a*a)+(b*b)-(c*c))/(2*a*b));

    //vectores
    vcen = new PVector(vlist[icen].x,vlist[icen].y);
    vcur = new PVector(vlist[n-1].x,vlist[n-1].y);
	
    PVector vnex = PVector.sub(vcur,vcen);
   
    vnex.normalize();
    vnex.mult(b);
    vnex.rotate(ang);
    vnex.add(vcen);
    //println(vcen,vcur,vnex);
    //line(vcen.x,vcen.y,vnex.x,vnex.y);

    for (int q = n-1; q > 0; q = q-1) {
      float di = dist(vnex.x,vnex.y,vlist[q].x,vlist[q].y);
      float ra = rad[n]+rad[q];
      if (di < ra-0.001) {
        toca = true;
        icen = q;
      }
    }
    //println(toca);
    if (toca == true){
      n=n-1;
    } else {
      vlist[n] = new PVector(vnex.x,vnex.y);
      //println(vlist[n]);
      //ellipse(vlist[n].x,vlist[n].y,rad[n],rad[n]);

      }
    toca = false;
    } //while
  return vlist;
  }
}
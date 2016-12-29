/* @pjs preload="11_Garces.png,12_Garces.png,14_Greene.png,18_Hidalgo.png,19_Hurtubia.png,2_Alonso.png,20_Iturriaga.png,21_Iturriaga.png,
23_Moris.png,25_Moris.png,26_Ojeda.png,27_Palmarola.png,31_Quintana.png,32_Quintanilla.png,34_Rosas.png,36_Saravia.png,
37_Torrent.png,4_Vera.png,4_Vera.png,40_Ugarte.png,41_Ugarte.png,42_Vasquez.png,8_Encinas.png,
9_Forray.png,empty.png"; font="arial.ttf";*/

Table tabla = new Table("investigaciones_UTF8.txt");
int n_proy = (tabla.getRowCount())-1;

// Variables
float z = 1;
int altf = 210;
int altt = 200;
int alnp = 0;
int alcp = 0;
int act0, act1, idp, idpf;
String sobreImagen;
float mx, my, tr, px, py, md, rc, pd, lz, rg;
boolean mov, zoom, deZoom, zoom2, deZoom2, 
  fueraTema, fueraProyecto, proyectos, detalle, nact, mlink, clust;

// Vectores
PVector va = new PVector(0,0);
PVector vz = new PVector(0,0);
PVector vz2 = new PVector(0,0);
PVector vf = new PVector(0,0);
PVector vg;

// LISTAS dos dimensiones
int[][] temas;
float[][] trad, tnint;
String[][] tnpro, repr, cab;

// LISTAS una dimension
String[] ntemas, menu, name, nombres, npro, res, pimg, redi, cont;
int[] act = new int[2];
int[] fondo = {255,255,255};
int[] linea = {0,0,0};
int[] hl = {0,0,0};
float[] rad, radt, nint;
PVector[] tcen, pcen, vec;
PImage[] imgl = new PImage[n_proy];


//--------------------------------SETUP--------------------------------------//

void setup(){
  background(255);
  size(800,600);
  smooth(8);
  
  PFont u8 = loadFont("arial.ttf");
  textFont(u8, 12); 
  int[] a = {0};
  temas = anatema(false);
  PImage myImage = loadImage("empty.png");
  ntemas = loadStrings("ListaTemas_UTF8.txt");
  nint = tabla.getStringColumn("INTEGRANTES");          // n integrantes por proyecto
  npro = tabla.getStringColumn("NOMBRE PROYECTO");      // nombres proyectos
  pimg = tabla.getStringColumn("REFERENCIA IMAGEN");
  cont = tabla.getStringColumn("URL");
  redi = tabla.getStringColumn("REDIRECT");
  rad = pondera(30);               						// radios por proyecto
  res = rese(); 
  radt = radii(temas);           						// radio total temas
  cab = cabros();
  
  for (int n = 0; n < pimg.length; n ++){
    imgl[n] = loadImage(pimg[n]);
  }
  
  trad = traduccion(temas,rad);     // LISTA radios
  tnint = traduccion(temas,nint);   // LISTA N integrantes
  tnpro = trad_s(temas,npro);       // LISTA Nombres proyectos
  repr = trad_s(temas,res);
  
// CIRCLE PACKING INICIAL
  Cpack t = new Cpack(radt,0,0);
  tcen = t.centros();

// LISTAS LIMPIAS
  clean(trad,rad);
  clean(tnint,nint);
  clean_s(tnpro,npro);
  clean(temas,a);
}

void reset(){
}
  
//--------------------------------DRAW--------------------------------------//
void draw() {
  
// SETTINGS
  background(fondo[0],fondo[1],fondo[2]);
  fill(0,100);
  textSize(8);
  textAlign(LEFT,TOP);
  text("MOUSE-LEFT = ZOOM IN / MOVE   ||   MOUSE-RIGHT = ZOOM OUT",0,0,width,30);
  textAlign(RIGHT,TOP);
  text("MAPA DE INVESTIGACIONES ESCUELA DE ARQUITECTURA UC",0,0,width,30);

  pushMatrix();
  
  float px = (width/2)-(va.x*z);
  float py = (height/2)-(va.y*z);
  translate(px,py);
    
    
    
// MOVIMIENTO Y ZOOM
  scale(z);
  if (mov == true) {
    tr += 0.05;
    translate((vf.x)*tr,(vf.y)*tr);
  }

  if (zoom == true) {
    z += 0.1;
    if (altf > 0) { altf -= 7; }
    if (altt > 0) { altt -= 10; }
    if (alnp >= 0) { alnp += 10; }
    if (alcp < 255) { alcp += 10; }
  }

  if (deZoom == true) {
    z -= 0.1;
    if (altf < 210) { altf += 4.2; }
    if (altt < 200) { altt += 10; }
    if (alnp < 200) { alnp -= 10; }
    if (alcp > 0) { alcp -= 10; }
  }

  if (zoom2 == true && detalle == false) {
    z += lz*0.06;
  }

  if (deZoom2 == true) {
    z -= lz*0.06;
  }

// GRUPOS
  int n = 0;
  fueraTema = true;
  fueraProyecto = true;
  for (PVector p : tcen){
    md = dist(mouseX-(px),mouseY-(py),(p.x)*z,(p.y)*z);
    if (md > radt[n]*z){
      fueraTema = fueraTema && true;
      hl[0] = 150; hl[1] = 150; hl[2] = 150;
    } else {
      fueraTema = fueraTema && false;
      vz = PVector.mult(p,z);
      rc = radt[n]*z;
      hl[0] = 100; hl[1] = 100; hl[2] = 100;
      act[0] = n;
    }

// CIRCLE PACKING PROYECTOS
    Cpack c = new Cpack(trad[n],p.x,p.y);
    PVector[] vec = c.centros();
    if (n == act0){
      pcen = vec;
    }
    int m = 0;
    
// PROYECTOS
    for (PVector v : vec){

      float st = 0.1;
      int sc = linea[0];
      int f = 0;
      boolean nombres = false;
      if (proyectos == true){
        pd = dist(mouseX-(px),mouseY-(py),(v.x)*z,(v.y)*z);
          if (pd > trad[n][m]*z){
            fueraProyecto = fueraProyecto && true;
            st = 0.1;
          } else {
            fueraProyecto = fueraProyecto && false;
            vz = v;
            if (detalle == false && zoom2 == false){st = 0.2;}
            if (act0 == act[0]){act[1] = m;}
            idp = temas[n][m];
          }
      }
      
// OCULTA GRUPO
     if (detalle == true){
        alnp = 0;
        if (m == act1){
          sc = linea[0];
          f = 0;
          nombres = true;
        } else {
          sc = -1;
          f = -1;
          nombres = false;
        }
      }

      int w = temas[n][m];

      if (n == act0){
        Projekt pro = new Projekt(v,trad[n][m],int(nint[w]),repr[n][m], cab[w]);
        pro.circulo(null,linea[0],sc,alcp,st);
        float rr = trad[n][m]*2*z;
        float ff = map(rr,trad[n][m],height*0.75,0.8,1.0);
        if (zoom2 == false && deZoom2 == false && detalle == false){
          pro.ptos(0,f,alcp,sc,0.5,ff);
        } 
        if ((zoom2 == true || deZoom2 == true) && m == act1){ 
          pro.ptos(0,f,alcp,sc,0.5,ff);
        }
         if (detalle == true && m == act1){ 
          pro.ptos(0,f,alcp,sc,0.5,ff);
        }
      }  
    m++;
    }
    
// CIRCULOS GRUPOS
    Projekt tem = new Projekt(p,radt[n],0,ntemas[n],name);
    tem.circulo(hl,altf,-1,255,0.2);
    tem.titulo(10, linea, altt);
    n++;
  }

  popMatrix();
  
// IMAGENES
  if (proyectos == true && detalle == false && zoom2 == false && deZoom2 == false){
    imageMode(CENTER);
    PImage im = imgl[temas[act0][act[1]]];
    im.resize(0,int(trad[act0][act[1]]*z*2*0.99));
    tint(255, 155);
    image(im, ((pcen[act[1]].x)*z)+px+((vf.x*z)*tr), ((pcen[act[1]].y)*z)+py+((vf.y*z)*tr));
  }
  
// FIN MOVIMIENTO
  if (tr > 1) { 
    va  = new PVector(vg.x,vg.y);
    mov = false;
    tr  = 0;
  }
  
// FIN ZOOM
  if (radt[act0]*z*2 > height*1.5 && proyectos == false && zoom == true) {
    zoom = false;
    proyectos = true;
  }

// FIN ZOOM2
  if (proyectos == true && detalle == false && trad[act0][act1]*z*2 > height*0.75
      && zoom2 == true){
    zoom2 = false;
    detalle = true;
  }
  
// FIN DEZOOM
  if (radt[act0] >= radt[act0]*z) { 
    z = 1;
    alnp = 0;
    deZoom = false;
    proyecto = false;
  }
  
// FIN DEZOOM2
  if (radt[act0]*z*2 < height*1.5 && deZoom2 == true) {
    deZoom2 = false;
    detalle = false;
  }
  
//ID PROYECTOS 
  if (proyectos == true && detalle == false){
    rectMode(CORNER);
    fill(255);
    rect(0,height-60,width,height);
    fill(0);
	int d = 50;
    if (act[0] == act0 && zoom == false && deZoom == false){
      textSize(20);
      textAlign(CENTER,CENTER);
      if (temas[act[0]][act[1]] > 9){
    	text("P."+str(temas[act0][act[1]]),0,height-d,d,d);
      }else{
        text("P.0"+str(temas[act0][act[1]]),0,height-d,d,d);
      }
      textSize(11);
      textAlign(LEFT,TOP);
      text(ntemas[act0],0,height-d,width,d);
      textSize(10);
      textAlign(LEFT,CENTER);
      text(tnpro[act0][act[1]],d,height-d,width-d,d);
    }
  }
  
  if (detalle == true){
//IMAGEN
    imageMode(CENTER);
    imagen = imgl[temas[act0][act1]];
    imagen.resize(0,int(trad[act0][act1]*z*2*0.99));
    tint(255, 90);
    image(imagen, width/2, height/2);
    filter((BLUR,12), imagen);
    
//ID PROYECTO
    rectMode(CORNER);
    fill(255);
    rect(0,height-60,width,height);
    fill(0);
    int d = 50;
    textSize(20);
    textAlign(CENTER,CENTER);
    if (temas[act0][act1] > 9){
      text("P."+str(temas[act0][act1]),0,height-d,d,d);
    }else{
      text("P.0"+str(temas[act0][act1]),0,height-d,d,d);
    }
    textSize(11);
    textAlign(LEFT,TOP);
    text(ntemas[act0],0,height-d,width,d);
    textSize(10);
    textAlign(LEFT,CENTER);
    text(tnpro[act0][act1],d,height-d,width-d,d);
    
// RESEÑA
    rectMode(RADIUS);
    float st = trad[act0][act1]*z*0.05;
    textSize(st);
    textLeading(trad[act0][act1]*z*0.05);
    textAlign(LEFT,CENTER);
    fill(0,0,0,255);
    rectMode(RADIUS);
    float r = trad[act0][act1];
    float u = r*z*0.4;
    float mw = (width/2)-u;
    float mh = (height/2)-u;
    text(repr[act0][act1], mw, mh,u*2,u*2);
    float w = textWidth(cont[temas[act0][act1]]);
    if (mouseX > mw && mouseX < mw+w &&
        mouseY > mh+(u*2) && mouseY < mh+(u*2)+(st*2)){
      mlink = true; fill(0);
    } else { mlink = false; fill(100);}
    text(str(cont[temas[act0][act1]]), mw, mh+(u*2),w,st*2);
    noFill();
    
// PERSONAS
    pp();
  }
  println(act[0]+" / "+act[1]);
  println(act0+" / "+act1);
}

//----------------------------FUNCIONES--------------------------------------//

float[][] traduccion(int[][] lista, float[] fuente) {
   //println(lista[0][0],fuente[0]);
  float[][] ltrad = new float[lista.length][lista[0].length];
  for (int n = 0; n < lista.length; n++){
    int c = 0;
    for (int m : lista[n]){
      //println(n,c,m);
      ltrad[n][c] = fuente[m];
      c++;
      }
    }
  return ltrad;
}

String[][] trad_s(int[][] lista, String[] fuente) {
  String[][] ltrad = new String[lista.length][lista[0].length];
  for (int n = 0; n < lista.length; n++){
    int c = 0;
    for (int m : lista[n]){
      ltrad[n][c] = fuente[m];
      c++;
      }
    }
  return ltrad;
}

void clean(float[][] lista, float[] lista2){
  float fin = lista2[0];
  for (int s = 0; s < lista.length; s=s+1){
    int n = lista[s].length-1;
    if (lista[s][n] == fin){
      while (lista[s][n] == fin){
        lista[s] = shorten(lista[s]);
        n = n-1;
      }
    }
  }
}

void clean(int[][] lista, int[] lista2){
  int fin = lista2[0];
  for (int s = 0; s < lista.length; s=s+1){
    int n = lista[s].length-1;
    if (lista[s][n] == fin){
      while (lista[s][n] == fin){
        lista[s] = shorten(lista[s]);
        n = n-1;
      }
    }
  }
}

void clean_s(String[][] lista, String[] lista2){
  String fin = lista2[0];
  for (int s = 0; s < lista.length; s=s+1){
    int n = lista[s].length-1;
    if (lista[s][n] == fin){
      while (lista[s][n] == fin){
        lista[s] = shorten(lista[s]);
        n = n-1;
      }
    }
  }
}

void pp() {
  	int w = temas[act0][act1];
    float angle = TWO_PI / nint[w];
    int q = 0;
    for (float t = 0; t < TWO_PI; t += angle) {
      float sx = cos(t) * trad[act0][act1]*z;
      float sy = sin(t) * trad[act0][act1]*z;
      float tx = cos(t) * trad[act0][act1]*0.8*z;
      float ty = sin(t) * trad[act0][act1]*0.8*z;
      
      strokeWeight(1/z);
      stroke(0,255);
      fill(0,255);

      pushMatrix();
      textSize(9);
      translate(sx+(width/2),sy+(height/2));
      if (t > HALF_PI && t < PI+HALF_PI || t == HALF_PI){
        rotate(t-PI);
        translate(trad[act0][act1]*0.05*z,0);
        textAlign(LEFT,CENTER);
      }
      else if (t < HALF_PI || t > PI+HALF_PI || t == 0 || t == HALF_PI*3) {
        rotate(t);
        translate(-trad[act0][act1]*0.05*z,0);
        textAlign(RIGHT,CENTER);
      }
      fill(0,0,0);
      text(cab[w][q],0,0);
      popMatrix();
      q++;
    }
 }
  
void mouseClicked(){
  float x = (width/2);
  float y = (height/2);
  float d = dist(mouseX,mouseY,x,y);
  if (proyectos == true){rc = trad[act0][act1]*z;} else {rc = radt[act0]*z;}
  
  if (rc < d) {
    if (mouseButton == LEFT && fueraTema == false && mov == false &&
      zoom == false && zoom2 == false && deZoom == false && deZoom2 == false
      && detalle == false && proyectos == false){ //move temas
      vf = PVector.sub(va,vz);
      vg = vz;
      mov = true;
      act0 = act[0];
    }
    if (mouseButton == LEFT && fueraProyecto == false && mov == false &&
      zoom == false && zoom2 == false && deZoom == false && deZoom2 == false
      && detalle == false && proyectos == true && act[0] == act0){ //move proyectos
      vf = PVector.sub(va,vz);
      vg = vz;
      mov = true;
      act1 = act[1];
      idpf = idp;
    }
  }
  if (rc > d) {
    if (mouseButton == LEFT && proyectos == false && mov == false
      && deZoom == false && deZoom2 == false){ //zoom 1
      zoom = true;
      menu = name;
    }
    if (mouseButton == LEFT && mov == false && proyectos == true && detalle == false
      && deZoom == false && deZoom2 == false && fueraProyecto == false){ // zoom 2
      zoom2 = true;
      lz = (height/rc)-1;
      rg = rc;
      act1 = act[1];
    }
  }
  if (mouseButton == RIGHT && proyectos == true && detalle == false
    && zoom2 == false && zoom == false && deZoom == false && deZoom2 == false){ //dezoom 1
    deZoom = true;
    proyectos = false;
    act[0] = 0;
    act[1] = 0;
    act1 = 0;
  }
  if (mouseButton == RIGHT && proyectos == true && detalle == true
    && zoom2 == false && zoom == false && deZoom == false && deZoom2 == false){ //dezoom 2
    deZoom2 = true;
    detalle = false;
    alnp = 255;
  }
  if (mouseButton == LEFT && mlink == true && detalle == true){
    link(cont[temas[act0][act1]], "_new");
  }
}

/*
void keyPressed(){
  if (key == 'r'){
    // Variables
z = 1;
altf = 210;
altt = 200;
alnp = 0;
alcp = 0;
act0, act1, idp, idpf = 0;
mx, my, tr, px, py, md, rc, pd, lz, rg = false;
mov, zoom, deZoom, zoom2, deZoom2, fueraTema, fueraProyecto, proyectos, detalle, nact, mlink = false;

// Vectores
va = new PVector(0,0);
vz = new PVector(0,0);
vz2 = new PVector(0,0);
vf = new PVector(0,0);
vg = new PVector(0,0);

// LISTAS dos dimensiones
int[][] temas;
float[][] trad, tnint;
String[][] tnpro, repr, cab;

// LISTAS una dimension
String[] ntemas, menu, name, nombres, npro, res, pimg, redi, cont;
int[] act = new int[2];
int[] fondo = {255,255,255};
int[] linea = {0,0,0};
int[] hl = {0,0,0};
float[] rad, radt, nint;
PVector[] tcen, pcen, vec;
PImage[] imgl = new PImage[n_proy];

  }
}
*/
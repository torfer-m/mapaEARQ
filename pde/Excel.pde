String[] rese(){
    String[] rese = new String[n_proy];
    String[] re = tabla.getStringColumn("RESENA");
  	for (int n = 0; n < n_proy; n++){
      rese[n] = re[n];
      c++;
      }
    return rese;
	}

String[][] cabros(){

    String[][] cabros = new String[n_proy][13];
	int c = 0;
    String p[];
  
    String[] i0 = tabla.getStringColumn("RESPONSABLE");
  	for (String s : i0){
      if (s.equals("")){}else{p = splitTokens(s,".("); s = p[1];}
      cabros[c][0] = s;
      c++;
    }
 
      for (int n = 1; n<13; n++){
        String header = "EQUIPO " + str(n);
        String[] col = tabla.getStringColumn(header);
        c = 0;
        for (String s : col){
          if (s.equals("")){} else {p = splitTokens(s,".("); s = p[1];}
          cabros[c][n] = s;
          c++;
        }
      }
  return cabros;
}

float[] pondera(float fac) {
  float[] radios = tabla.getFloatColumn("PONDERACION");
  int c = 0;
  for (float p : radios) { 
    p = str(p);    
    p = p.replace(",",".");
	radios[c] = float(p) * fac;
    c = c+1;
    }
    return radios;
}

int[][] anatema(boolean cluster){
  if (cluster == false) {
    String listaTemas[] = loadStrings("ListaTemas_UTF8.txt");
    int[][] lista = new int[listaTemas.length][30];
    String[] t1 = tabla.getStringColumn("TEMA 1");
    String[] t2 = tabla.getStringColumn("TEMA 2");
    String[] t3 = tabla.getStringColumn("TEMA 3");
    int c = 0;  
    for (String tema : listaTemas){
      int cc = 0;
      for (int n = 0; n < n_proy; n++) {
        String st1 = t1[n];
        String st2 = t2[n];
        String st3 = t3[n];
        if (tema.equals(st1) || tema.equals(st2) || tema.equals(st3)){
          lista[c][cc] = n;
          cc++;
        } 
      }
    c++;
    }
  } else {
    String listaCluster[] = loadStrings("ListaCluster_UTF8.txt");
    int[][] lista = new int[listaTemas.length][30];
    String[] t = tabla.getStringColumn("CLUSTER");
    int c = 0;  
    for (String cluster : listaCluster){
      int cc = 0;
      for (int n = 0; n < n_proy; n++) {
        String st = t[n];
        if (cluster.equals(st)){
          lista[c][cc] = n;
          cc++;
        } 
      }
    c++;
    }   
  }
  return lista;
}

float[] radii(int[][] lista){
  float[] rt = new float[lista.length];
  for (int n = 0; n < lista.length; n++){
    float r = 0;
    for (int t : lista[n]){
      r = r + t;
    }
    r = map(r,100,700,50,150);
    rt[n] = r;  
  }
  return rt;
}

float[][] traduccion(int[][] lista, float[] fuente) {
   //println(lista[0][0],fuente[0]);
  float[][] ltrad = new float[lista.length][lista[0].length];
  for (int n = 0; n < lista.length; n++){
    int c = 0;
    for (int m : lista[n]){
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
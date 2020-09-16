/* 
    Búsqueda en Amplitud
    
    Para mostrar recorridos en espacios de búsqueda
    
    Miguel Angel NOrzagaray Cosío
    UABCS/DSC
*/

import java.util.Queue;
import java.util.ArrayDeque;

int RadioMin = 10, RadioMax = 12;
int Radio = 10;
boolean MostrarId = false;
boolean Buscando = false;

int Divisiones=20;

int AnchoPincel = 2;
int SizeId = 12;

int Tabulador = 8;

color ColorFondo = 240;

color colorNodoMeta = #FF00FF;

// Para la edición inicial
color ColorNodoNormal = #80a0FF;
color ColorNodoTocado = #0000FF;
color ColorNodoMarcado = #80FF80;
color ColorNodoMarcadoTocado = #00FF00;
color ColorNodoVecino = #FF8000;

// Para el recorrido
color ColorNoVisitado = #0000FF;
color ColorPendiente = #00FF00;
color ColorVisitado = #FFFF00;
color ColorCamino = #F000F0;

color ColorAristaNormal = 150;
color COlorAristaAdyacente = 50;

int MaxNodos = 32;
int NodosMarcados = 0;

boolean MoviendoNodo = false;
boolean MarcandoNodos = false;

Nodo NodoEnMovimiento;
Nodo NodoMarcado1, NodoMarcado2;

int CuantosNodosHay = 0;

ArrayList<Nodo> Nodos = new ArrayList();
Queue<Nodo> Cola = new ArrayDeque();

void setup()
{
    int rmin,rmax;
    Nodo n,v;
    size(800,600);
    int T = height/Divisiones;
    int M = 5;  // Desorden
      
    for ( int i=0 ; i<Divisiones ; i++ )
        for ( int j=0 ; j<Divisiones ; j++ ) {
              n = new Nodo( int(j*T+T/2+random(-T/M,T/M)),      // Columna
                            int(i*T+T/2+random(-T/M,T/M)) );    // Fila
              Nodos.add(n);
              if ( random(90)<1 )
                n.Color = colorNodoMeta;
        }
    rmin = 2;
    rmax = 3;
    for ( int i=1 ; i<Divisiones ; i++ )
        for ( int j=1 ; j<Divisiones ; j++ ) {
            n = Nodos.get(i*Divisiones+j);
            
            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get(i*Divisiones+j-1);
                n.AgregarArista(v);
            }

            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get((i-1)*Divisiones+j);
                n.AgregarArista(v);
            }
        }
      
    rmin = 5;
    rmax = 3;
    for ( int i=1 ; i<Divisiones-1 ; i++ )
        for ( int j=1 ; j<Divisiones-1 ; j++ ) {
            n = Nodos.get(i*Divisiones+j);

            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get((i-1)*Divisiones+j-1);
                n.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get((i-1)*Divisiones+j+1);
                n.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get((i+1)*Divisiones+j-1);
                n.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos.get((i+1)*Divisiones+j+1);
                n.AgregarArista(v);
            }
        }
  
    rmin = 2;
    rmax = 4;
    for ( int i=1 ; i<Divisiones ; i++ ) {
        n = Nodos.get(i);
        if ( random(rmin) < random(rmax) ) {
            v = Nodos.get(i-1);
            n.AgregarArista(v);
        }
        n = Nodos.get(i*Divisiones);
        if ( random(rmin) < random(rmax) ) {
            v = Nodos.get((i-1)*Divisiones);
            n.AgregarArista(v);
        }
    }
}

void draw()
{
    background(ColorFondo);
    cursor(CROSS);
    strokeWeight(AnchoPincel);
  
    for (Nodo n : Nodos) 
        n.DibujarAristas();
  
    if ( !Buscando ) {
        for (Nodo n : Nodos) {
            if ( MostrarId || n.SeMuestraOrden )
                n.MostrarOrden();
            if ( n.mouseIn()==true ) {
                if ( n.Color != colorNodoMeta )
                    n.Color = n.Marcado ? 
                        ColorNodoMarcadoTocado : ColorNodoTocado;
                n.MostrarId();
            } else
                if ( n.Color != colorNodoMeta )
                  n.Color = n.Marcado ? 
                    ColorNodoMarcado : ColorNodoNormal;
            if ( n.Vecino == true )
                if ( n.Color != colorNodoMeta )
                    n.Color = ColorNodoVecino;
        }

        // Aquí inicia el algoritmo de búsqueda en amplitud
        if ( NodosMarcados > 0  &&  key == ' ' ) {
            Buscando = true;
            for (Nodo n : Nodos) {
                if ( n.Color != colorNodoMeta )
                  n.Color = ColorNoVisitado;
                n.Marcado = n.Vecino = false;
            }
            Cola.add(NodoMarcado1);
        }
    } else if ( Buscando ) {
        // Iteraciones de la búsqueda en amplitud
        Nodo u;
        if ( !Cola.isEmpty() ) {
            u = Cola.poll();
            for ( Nodo v : u.aristas ) {
                if ( v.Color == colorNodoMeta ) {
                    v.padre = u;
                    ObjetivoEncontrado(v);
                }
                if ( v.Color  == ColorNoVisitado ) {
                    v.Color = ColorPendiente;
                    v.padre = u;
                    Cola.add(v);
                }
            }
            u.Color = ColorVisitado;
            //noLoop();
        }
    }
    for (Nodo n : Nodos)
        n.Dibujar(); //<>//
}

void ObjetivoEncontrado(Nodo p)
{
    fill(0);
    textSize(24);
    text("¡Nodo objetivo", 620, 50);
    text("encontrado!", 620, 80);
    noStroke();
    fill(ColorCamino);
    circle(p.x, p.y, Radio+5);
    print("p="+p.Id);
    while ( p.padre != null ) {
      fill(ColorCamino);
      circle(p.x, p.y, Radio+5);
      p.MostrarId();
      print(" -> "+p.padre.Id);
      p = p.padre;
    }
    p.Color = colorNodoMeta;
    p.Dibujar();
    noFill();
    circle(p.x, p.y, Radio+5);
    p.MostrarId();
    noLoop();
}

void mouseClicked()
{
  Nodo n = null;
  
  if ( Buscando ) {
    redraw();
    return;
  }

  for ( Nodo a : Nodos) {
    if ( a.mouseIn() ) {
      n = a;
      break;
    }
  }
  if ( n == null )
    return;

  switch ( NodosMarcados ) {
    case 0:
      NodosMarcados = 1;
      NodoMarcado1 = n;
      for ( Nodo v : n.aristas )
        v.Vecino = true;
      break;
    case 1: 
      // Click sobre nodo marcado lo desmarca
      if ( NodoMarcado1 == n ) {
        NodosMarcados = 0;
        for ( Nodo v : n.aristas )
          v.Vecino = false;
      } 
      break;
    }

    n.Marcado = !n.Marcado;
    if ( n.Color != colorNodoMeta )
        n.Color = n.Marcado ? ColorNodoMarcado : ColorNodoNormal;

} // mouseClicked

void mouseDragged() 
{
  if ( MoviendoNodo == false  &&  mouseButton == LEFT ) {
    for (Nodo n : Nodos) {
      if ( n.mouseIn()==true ) {
        MoviendoNodo = true;
        NodoEnMovimiento = n;
      }
    }
  }
  if (MoviendoNodo == true )
    NodoEnMovimiento.Mover(mouseX,mouseY);
}

void mouseReleased() 
{
  MoviendoNodo = false;
  NodoEnMovimiento = null;
}

void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();

  Radio += e;
  if ( Radio < RadioMin )
      Radio = RadioMin;
  if ( Radio > RadioMax )
      Radio = RadioMax;
}

/* Fin de archivo */

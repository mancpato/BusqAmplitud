/* 
    Para mostrar recorridos en espacios de búsqueda
    
    Búsqeuda en Amplitud
*/

import java.util.Queue;
import java.util.ArrayDeque;

int RadioMin = 10, RadioMax = 12;
int Radio = 10;
boolean MostrarId = false;
boolean Buscando = false;
boolean Avanzar = false;
boolean Arre = false;
int OrdenDeVisita = 0;

int Divisiones=14;

int AnchoPincel = 2;
int SizeId = 12;

int Tabulador = 8;

color ColorFondo = 240;

// Para la edición inicial
color ColorNodoNormal = #8080FF;
color ColorNodoTocado = #0000FF;
color ColorNodoMarcado = #80FF80;
color ColorNodoMarcadoTocado = #00FF00;
color ColorNodoVecino = #FF8000;

// Para el recorrido
color ColorNoVisitado = #0000FF;
color ColorPendiente = #00FF00;
color ColorVisitado = #FFFF00;

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
                n.Color = n.Marcado ? ColorNodoMarcadoTocado : ColorNodoTocado;
                n.MostrarId();
            } else
                n.Color = n.Marcado ? ColorNodoMarcado : ColorNodoNormal;
            if ( n.Vecino == true )
                n.Color = ColorNodoVecino;
        }

        // Aquí inicia el algoritmo de búsqueda en amplitud
        if ( NodosMarcados == 1 && key == ' ' ) {
            Buscando = true;
            for (Nodo n : Nodos) {
                n.Color = ColorNoVisitado;
                n.Marcado = n.Vecino = false;
            }
            Cola.add(NodoMarcado1);
            NodoMarcado1.OrdenDeVisita = OrdenDeVisita++;
            NodoMarcado1.SeMuestraOrden = true;
            Avanzar = true;
        }
    } else if ( Arre || Avanzar ) {
        // Iteraciones de la búsqueda en amplitud
        Nodo u;
        if ( !Cola.isEmpty() && key==' ' ) {
            u = Cola.poll();
            for ( Nodo v : u.aristas ) {
                if ( v.Color  == ColorNoVisitado ) {
                    v.Color = ColorPendiente;
                    v.OrdenDeVisita = OrdenDeVisita++;
                    v.SeMuestraOrden = true;
                    Cola.add(v);
                }
            }
            u.Color = ColorVisitado;
            u.SeMuestraOrden = false;
            if ( !Arre )
                Avanzar = false;
            //delay(50);
        }
    }
    for (Nodo n : Nodos) {
        if ( n.SeMuestraOrden )
            n.MostrarOrden();
        n.Dibujar();
    }
    if ( !Avanzar  &&  ( key == 'a' || key == 'A' ) ) //<>//
        Arre = true;
}

void mouseClicked()
{
  Nodo n = null;
  
  if ( Buscando ) {
    Avanzar = true;
    return;
  }

  // Nuevo nodo o arista
  if ( mouseButton == RIGHT ) {
    
    // Mouse sobre un nodo: no se agrega nada
    for ( Nodo a : Nodos ) 
      if ( a.mouseIn() )
        return;
    
    if ( NodosMarcados == 2 ) {
      
        if ( NodoMarcado1.aristas.contains(NodoMarcado2) ) {
            println(NodoMarcado1.Id+" y "+NodoMarcado2.Id+" son adyacentes");
            return;
        }
        NodoMarcado1.AgregarArista(NodoMarcado2);
        println("Se agrega arista entre "+NodoMarcado1.Id+" y "+NodoMarcado2.Id);
    }
  
  } else { // Botón izquierdo: marcar
  
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
        } else {
          NodoMarcado2 = n;
          NodosMarcados = 2;
          NodoMarcado2.Vecino = false;
          IntersectarVecindadesAbiertas();
        }
        break;
      case 2:
        // Click sobre nodo marcado lo desmarca
        if ( NodoMarcado1 == n ) {
          NodosMarcados = 1;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = false;
          for ( Nodo v : NodoMarcado2.aristas )
            v.Vecino = true;
          NodoMarcado1 = NodoMarcado2;
          NodoMarcado2 = null;
        } else if ( NodoMarcado2 == n ) {
          NodosMarcados = 1;
          for ( Nodo v : NodoMarcado2.aristas )
            v.Vecino = false;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = true;
          NodoMarcado2 = null;
        } else {
          NodoMarcado1.Marcado = false;
          for ( Nodo v : NodoMarcado1.aristas )
            v.Vecino = false;
          NodoMarcado1.Color = ColorNodoNormal;
          NodoMarcado1 = NodoMarcado2;
          NodoMarcado2 = n;
          IntersectarVecindadesAbiertas();
        }
        break;
      } // switch

      n.Marcado = !n.Marcado;
      n.Color = n.Marcado ? ColorNodoMarcado : ColorNodoNormal;
  } // Botón izquierdo
  
} // mouseClicked

void IntersectarVecindadesAbiertas()
{
  for ( Nodo v : NodoMarcado1.aristas )
    if ( NodoMarcado2.aristas.contains(v) )
      v.Vecino = true;
    else
      v.Vecino = false;
  for ( Nodo v : NodoMarcado2.aristas )
    if ( NodoMarcado1.aristas.contains(v) )
      v.Vecino = true;
    else
      v.Vecino = false;
}

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
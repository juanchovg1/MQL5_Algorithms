//+------------------------------------------------------------------+
//| Indicador personalizado: Líneas verticales 04:00 y 08:00          |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

// Definir variables globales
color colorLinea = clrBlack; // Color de la línea
int anchoLinea = 2;          // Ancho de la línea

// Función para inicializar el indicador
int OnInit()
{
   // Dibujar las líneas de cada día
   DibujarLineasVerticales();
   
   return(INIT_SUCCEEDED);
}

// Función que se ejecuta en cada tick
int OnCalculate(const int rates_total, 
                const int prev_calculated, 
                const datetime &time[],
                const double &open[], 
                const double &high[], 
                const double &low[], 
                const double &close[],
                const long &tick_volume[], 
                const long &volume[], 
                const int &spread[])
{
   // Redibujar las líneas si es necesario
   DibujarLineasVerticales();
   
   return(rates_total);
}

// Función para dibujar las líneas verticales en las horas especificadas
void DibujarLineasVerticales()
{
   datetime timeStart, timeEnd;
   
   // Recorremos los últimos días y dibujamos las líneas en cada uno
   for (int i = 0; i < 10; i++) // Dibujar para los últimos 10 días
   {
      timeStart = iTime(NULL, PERIOD_D1, i) + 4 * 3600;  // 04:00 de cada día
      timeEnd = iTime(NULL, PERIOD_D1, i) + 8 * 3600;    // 08:00 de cada día
      
      // Dibujar la línea de las 04:00
      string nombreLinea04 = "Linea_04_" + IntegerToString(i);
      if (ObjectFind(0, nombreLinea04) == -1)
      {
         ObjectCreate(0, nombreLinea04, OBJ_VLINE, 0, timeStart, 0);
         ObjectSetInteger(0, nombreLinea04, OBJPROP_COLOR, colorLinea);
         ObjectSetInteger(0, nombreLinea04, OBJPROP_WIDTH, anchoLinea);
      }
      
      // Dibujar la línea de las 08:00
      string nombreLinea08 = "Linea_08_" + IntegerToString(i);
      if (ObjectFind(0, nombreLinea08) == -1)
      {
         ObjectCreate(0, nombreLinea08, OBJ_VLINE, 0, timeEnd, 0);
         ObjectSetInteger(0, nombreLinea08, OBJPROP_COLOR, colorLinea);
         ObjectSetInteger(0, nombreLinea08, OBJPROP_WIDTH, anchoLinea);
      }
   }
}

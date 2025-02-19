//+------------------------------------------------------------------+
//| Indicador personalizado para niveles de Fibonacci                |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

// Definir variables globales
double maxPrice, minPrice;
datetime lastDay;

// Función para inicializar el indicador
int OnInit()
{
   // Inicializar el último día
   lastDay = iTime(NULL, PERIOD_D1, 0); // Último día disponible
   
   // Cálculo inicial del rango de máximos y mínimos
   CalcularMaxMin();

   // Colocar los niveles de Fibonacci en el gráfico
   DibujarNivelesFibonacci();
   
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
   // Actualizar el cálculo de máximos y mínimos si el día ha cambiado
   datetime currentDay = iTime(NULL, PERIOD_D1, 0);
   
   if (lastDay != currentDay) 
   {
      lastDay = currentDay;
      CalcularMaxMin();
      DibujarNivelesFibonacci();
   }
   
   return(rates_total);
}

// Función para calcular los máximos y mínimos de las últimas 24 horas
void CalcularMaxMin()
{
   maxPrice = iHigh(NULL, PERIOD_D1, 0); // Máximo del día
   minPrice = iLow(NULL, PERIOD_D1, 0);  // Mínimo del día
}

// Función para dibujar los niveles de Fibonacci
void DibujarNivelesFibonacci()
{
   double rango = maxPrice - minPrice;

   // Dibujar las líneas de Fibonacci
   DibujarLineaFibonacci("Fibo_0", maxPrice);
   DibujarLineaFibonacci("Fibo_23_6", maxPrice - rango * 0.236);
   DibujarLineaFibonacci("Fibo_38_2", maxPrice - rango * 0.382);
   DibujarLineaFibonacci("Fibo_50", maxPrice - rango * 0.50);
   DibujarLineaFibonacci("Fibo_61_8", maxPrice - rango * 0.618);
   DibujarLineaFibonacci("Fibo_100", minPrice);
}

// Función para dibujar una línea de Fibonacci en el gráfico
void DibujarLineaFibonacci(string nombre, double nivel)
{
   color colorFibo = clrBlueViolet; // Color de las líneas de Fibonacci

   if (ObjectFind(0, nombre) == -1) // Si el objeto no existe, crearlo
   {
      ObjectCreate(0, nombre, OBJ_HLINE, 0, 0, nivel);
      ObjectSetInteger(0, nombre, OBJPROP_COLOR, colorFibo);
      ObjectSetInteger(0, nombre, OBJPROP_WIDTH, 1);
   }
   else // Si el objeto ya existe, actualizar su nivel
   {
      ObjectSetDouble(0, nombre, OBJPROP_PRICE, nivel); // Actualiza la posición de la línea horizontal
   }
}

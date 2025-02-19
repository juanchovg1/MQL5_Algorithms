//+------------------------------------------------------------------+
//| Indicador personalizado para niveles de Fibonacci semanales      |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

// Definir variables globales
double maxPrice, minPrice;
datetime lastWeek;

// Función para inicializar el indicador
int OnInit()
{
   // Inicializar la última semana
   lastWeek = iTime(NULL, PERIOD_W1, 0); // Última semana disponible
   
   // Cálculo inicial del rango de máximos y mínimos
   CalcularMaxMinSemanal();

   // Colocar los niveles de Fibonacci en el gráfico
   DibujarNivelesFibonacciSemanal();
   
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
   // Actualizar el cálculo de máximos y mínimos si la semana ha cambiado
   datetime currentWeek = iTime(NULL, PERIOD_W1, 0);
   
   if (lastWeek != currentWeek) 
   {
      lastWeek = currentWeek;
      CalcularMaxMinSemanal();
      DibujarNivelesFibonacciSemanal();
   }
   
   return(rates_total);
}

// Función para calcular los máximos y mínimos de la última semana
void CalcularMaxMinSemanal()
{
   maxPrice = iHigh(NULL, PERIOD_W1, 0); // Máximo de la semana
   minPrice = iLow(NULL, PERIOD_W1, 0);  // Mínimo de la semana
}

// Función para dibujar los niveles de Fibonacci semanales
void DibujarNivelesFibonacciSemanal()
{
   double rango = maxPrice - minPrice;

   // Dibujar las líneas de Fibonacci
   DibujarLineaFibonacci("Fibo_0_W", maxPrice);
   DibujarLineaFibonacci("Fibo_23_6_W", maxPrice - rango * 0.236);
   DibujarLineaFibonacci("Fibo_38_2_W", maxPrice - rango * 0.382);
   DibujarLineaFibonacci("Fibo_50_W", maxPrice - rango * 0.50);
   DibujarLineaFibonacci("Fibo_61_8_W", maxPrice - rango * 0.618);
   DibujarLineaFibonacci("Fibo_100_W", minPrice);
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

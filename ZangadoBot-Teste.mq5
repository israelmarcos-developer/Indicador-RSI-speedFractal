//+------------------------------------------------------------------+
//|                                                   ZangadoBot.mq5 |
//|                                           israelmarcos.developer |
//|                                                 _061israelmarcos |
//+------------------------------------------------------------------+
#property copyright "israelmarcos.developer"
#property link      "_061israelmarcos"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Compra
#property indicator_label1  "Compra"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  0
//--- plot Venda
#property indicator_label2  "Venda"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  0
//--- plot RSI1
#property indicator_label3  "RSI1"
#property indicator_type3   DRAW_NONE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot RSI2
#property indicator_label4  "RSI2"
#property indicator_type4   DRAW_NONE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- input parameters
input int      Periodo1=14;
input int      Periodo2=14;
//--- indicator buffers
double         CompraBuffer[];
double         VendaBuffer[];
double         RSI1Buffer[];
double         RSI2Buffer[];
//--- Expiração
datetime Exp = D'22.04.2022'; //#########

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//+------------------------------------------------------------------+
//| Autenticação de segurança                                        |
//+------------------------------------------------------------------+
//--- Verificação de conta e exp
   if(TimeCurrent() > Exp)
     {
      Alert(">>>>> Contate o ADM para renovar sua Licença <<<<<");
      Print("Email:israelmarcos.developer@gmail.com");
      Print("WhatsApp: 61 98304-9851");
      return(INIT_FAILED);
     }
   if(AccountInfoInteger(ACCOUNT_LOGIN) != 50754538)  //#########
     {
      Alert("Acesso não autorizado para essa conta.");
      Alert(">>>>> Contate o ADM para renovar sua Licença <<<<<");
      Print("Email:israelmarcos.developer@gmail.com");
      Print("WhatsApp: 61 98304-9851");
     }
//+------------------------------------------------------------------+
//| Buffers e plotagens                                              |
//+------------------------------------------------------------------+
   SetIndexBuffer(0,CompraBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,VendaBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,RSI1Buffer,INDICATOR_DATA);
   SetIndexBuffer(3,RSI2Buffer,INDICATOR_DATA);
//--- Indicador visual compra e venda
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,10);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-10);

   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],
                const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[])
  {
//--- Chamando dados do RSI
   CopyBuffer(iRSI(_Symbol,_Period,Periodo1,PRICE_CLOSE),0,0,rates_total,RSI1Buffer);
   CopyBuffer(iRSI(_Symbol,_Period,Periodo2,PRICE_CLOSE),0,0,rates_total,RSI2Buffer);
//--- Lógica de VENDA
   for(int i=3; i<rates_total; i++)
     {
      if(RSI1Buffer[i] <= 75 && RSI1Buffer[i] >= 57 && RSI1Buffer[i-1] <= 75 && RSI1Buffer[i-1] >= 57)
        {
         if(high[i-1] > high[i-2] && high[i] > high[i-1])
           {VendaBuffer[i] = high[i];VendaBuffer[i-1] = 0;VendaBuffer[i-2] = 0;}
         else
           {VendaBuffer[i] = high[i];VendaBuffer[i-1] = 0;VendaBuffer[i-2] = 0;}
        }
      else{VendaBuffer[i] = 0;}
     }
//--- Lógica de COMPRA
   for(int i=3; i<rates_total; i++)
     {
      if(RSI2Buffer[i] >= 20 && RSI2Buffer[i] <= 40 && RSI2Buffer[i-1] >= 20 && RSI2Buffer[i-1] <= 40)
        {
         if(high[i-1] < high[i-2] && high[i] < high[i-1])
           {CompraBuffer[i] = low[i];CompraBuffer[i-1] = 0;CompraBuffer[i-2] = 0;}
         else
           {CompraBuffer[i] = low[i];CompraBuffer[i-1] = 0;CompraBuffer[i-2] = 0;}
        }
      else
        {CompraBuffer[i] = 0;}
     }
   return(rates_total);
  }
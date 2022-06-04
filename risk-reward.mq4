//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "NEO"
#property link      "Neo.Reverser@gmail.com"
#property version   "1.00"
#property description "Neo.Reverser@gmail.com"
#property indicator_chart_window

#include <forall.mqh>

input string bb = "========== Settings =========="; //Settings
extern color tp_rec_color = clrLightGreen;
extern color sl_rec_color = clrPink;
extern color en_line_color = clrTeal;
extern color tp_line_color = clrYellowGreen;
extern color sl_line_color = clrTomato;
input ENUM_LINE_STYLE _style2 = STYLE_SOLID;  //Style
input int   line_width = 2;
input string aa = "========== Keywords =========="; //Keywords
extern string OPEN_RR = "i";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
   {
    return(INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
   {
    return(rates_total);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void risk_reward(int noedit = 0, string n = "")
   {
    double p1, p2, p3, rec1, rec2, rec3, rr, sl, tp;
    datetime t1, t2;
    string obj_tp, obj_sl, obj_en_l, obj_tp_l, obj_sl_l, pass, myarray1[], space = "";
    if(noedit)
       {
        t1 = iTime(NULL, 0, WinMid);
        t2 = t1 + (66 * Period() * 60);
        p1 = ND(Price_Mid);
        p2 = ND(p1 - Price_F);
        p3 = ND(p1 + Price_F);
        pass = (string)MathRand() + (string)MathRand();
        obj_tp = "rrRectangle_tp " + (string)p1 + "-" + (string)p3 + " " + pass + " " + (string)MathRand();
        obj_sl = "rrRectangle_sl " + (string)p1 + "-" + (string)p2 + " " + pass + " " + (string)MathRand();
        obj_en_l = "rrTrendline_en " + (string) p1 + " " + pass;
        obj_tp_l = "rrTrendline_tp " + (string) p3 + " " + pass;
        obj_sl_l = "rrTrendline_sl " + (string) p2 + " " + pass;
        rec1 = p1;
        rec2 = p3;
        rec3 = p2;
        RectangleCreate(0, obj_tp, 0, t1, rec1, t2, rec2, tp_rec_color, 0, 1, true, true, false, false);
        RectangleCreate(0, obj_sl, 0, t1, rec1, t2, rec3, sl_rec_color, 0, 1, true, true, false, false);
        TrendCreate(0, obj_en_l, 0, t1, rec1, t2, rec1, en_line_color, _style2, line_width, true);
        TrendCreate(0, obj_tp_l, 0, t1, rec2, t2, rec2, tp_line_color, _style2, line_width, true);
        TrendCreate(0, obj_sl_l, 0, t1, rec3, t2, rec3, sl_line_color, _style2, line_width, true);
       }
    else
       {
        int size1;
        size1 = StringSplit(n, ' ', myarray1);
        p3 = ND((double)myarray1[1]);
        pass = myarray1[2];
        p1 = ND((double)ObjectGet(n, OBJPROP_PRICE1));
        p2 = ND((double)ObjectGet(n, OBJPROP_PRICE2));
        t1 = (datetime)ObjectGet(n, OBJPROP_TIME1);
        t2 = (datetime)ObjectGet(n, OBJPROP_TIME2);
        if(p1 == p3)
           {
            ObjectSet(n, OBJPROP_PRICE1, p2);
           }
        else
            if(p2 == p3)
               {
                ObjectSet(n, OBJPROP_PRICE2, p1);
               }
            else
               {
                ObjectSet(n, OBJPROP_PRICE2, p1);
               }
        obj_en_l = Find_obj("rrTrendline_en", pass);
        obj_tp_l = Find_obj("rrTrendline_tp", pass);
        obj_sl_l = Find_obj("rrTrendline_sl", pass);
        obj_tp = Find_obj("rrRectangle_tp", pass);
        obj_sl = Find_obj("rrRectangle_sl", pass);
        ObjectSet(obj_en_l, OBJPROP_TIME1, t1);
        ObjectSet(obj_tp_l, OBJPROP_TIME1, t1);
        ObjectSet(obj_sl_l, OBJPROP_TIME1, t1);
        ObjectSet(obj_en_l, OBJPROP_TIME2, t2);
        ObjectSet(obj_tp_l, OBJPROP_TIME2, t2);
        ObjectSet(obj_sl_l, OBJPROP_TIME2, t2);
        rec1 = ND((double)ObjectGet(obj_en_l, OBJPROP_PRICE1));
        rec2 = ND((double)ObjectGet(obj_tp_l, OBJPROP_PRICE2));
        rec3 = ND((double)ObjectGet(obj_sl_l, OBJPROP_PRICE2));
        //rec-tp
        ObjectSet(obj_tp, OBJPROP_TIME1, t1);
        ObjectSet(obj_tp, OBJPROP_TIME2, t2);
        ObjectSet(obj_tp, OBJPROP_PRICE1, rec1);
        ObjectSet(obj_tp, OBJPROP_PRICE2, rec2);
        //rec-sl
        ObjectSet(obj_sl, OBJPROP_TIME1, t1);
        ObjectSet(obj_sl, OBJPROP_TIME2, t2);
        ObjectSet(obj_sl, OBJPROP_PRICE1, rec1);
        ObjectSet(obj_sl, OBJPROP_PRICE2, rec3);
       }
    tp = ND(topip(MathAbs(rec2 - rec1)));
    sl = ND(topip(MathAbs(rec1 - rec3)));
    rr = ND(tp / sl);
    ObjectSetString(0, obj_en_l, OBJPROP_TEXT, space + "1:" + NS((string)rr, First_Digits(rr) + 3));
    ObjectSetString(0, obj_tp_l, OBJPROP_TEXT, space + NS((string)tp, First_Digits(tp) + 3));
    ObjectSetString(0, obj_sl_l, OBJPROP_TEXT, space + NS((string)sl, First_Digits(sl) + 3));
    ObjectSetString(0, obj_en_l, OBJPROP_NAME, new_obj_name(obj_en_l, rec1));
    ObjectSetString(0, obj_tp_l, OBJPROP_NAME, new_obj_name(obj_tp_l, rec2));
    ObjectSetString(0, obj_sl_l, OBJPROP_NAME, new_obj_name(obj_sl_l, rec3));
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string new_obj_name(string s, double p)
   {
    string myarray1[], mid_p;
    StringSplit(s, ' ', myarray1);
    mid_p = myarray1[1];
    StringReplace(s, mid_p, (string)p);
    return(s);
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int objexist(string pass)
   {
    int t = 0;
    for(int i = ObjectsTotal() - 1; i >= 0;  i--)
       {
        if(FindText(ObjectName(i), pass))
            ++t;
       }
    return(t);
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long & lparam, const double & dparam, const string & sparam)
   {
    if(id == CHARTEVENT_OBJECT_CLICK)
       {
        if(FindText(sparam, "rrTrendline") || FindText(sparam, "rrRectangle"))
           {
            risk_reward(0, sparam);
            WindowRedraw();
           }
       }
    if(id == CHARTEVENT_KEYDOWN)
       {
        short result = TranslateKey((int)lparam);
        string code = ShortToString(result);
        StringToLower(OPEN_RR);
        if(code == OPEN_RR)
           {
            risk_reward(1, sparam);
            WindowRedraw();
           }
        else
           {
            StringToUpper(OPEN_RR);
            if(code == OPEN_RR)
               {
                risk_reward(1, sparam);
                WindowRedraw();
               }
           }
        if(result == 91 || result == 1580)
           {
            ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, 1);
            WindowRedraw();
           }
        if(result == 93 || result == 1670)
           {
            ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, 0);
            WindowRedraw();
           }
       }
    if(id == CHARTEVENT_OBJECT_DELETE)
       {
        if((FindText(sparam, "rrRectangle") || FindText(sparam, "rrTrendline")))
           {
            string myarray1[], pass;
            int size1 = StringSplit(sparam, ' ', myarray1);
            pass = myarray1[2];
            if(objexist(pass) < 5)
               {
                DeleteObject2("rrRectangle", pass);
                DeleteObject2("rrTrendline", pass);
               }
           }
       }
   }


//+------------------------------------------------------------------+

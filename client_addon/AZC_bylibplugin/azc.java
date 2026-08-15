package com.saint.game.gui;

import android.app.Activity;
import android.util.Log;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.nvidia.devtech.NvEventQueueActivity;
import com.saint.game.R;
import com.saint.game.gui.util.Utils;
import java.io.UnsupportedEncodingException;

public class azc {
    public Activity activity;

    public ImageView closeazc;
    public ImageView azc80, azc92, azc95, azc98, azcpay, azc_cash, azc_card;

    public ConstraintLayout constraintLayout;
    public SeekBar fuelstation_bar;
    public TextView priceazc, litrash;

    int fuelstation_active, typemoney, fielstation_progress, fuelprice1, fuelprice2, fuelprice3, fuelprice4, fuelprice5, fuelprice;


    public azc(Activity aactivity){
        constraintLayout = aactivity.findViewById(R.id.azc);

        fuelprice1 = 10;
        fuelprice2 = 10;
        fuelprice3 = 10;
        fuelprice4 = 10;
        fuelprice5 = 10;

        azc_cash = aactivity.findViewById(R.id.azc_cash);
        azc_cash.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc_cash.setImageResource(R.drawable.family_cash);
                azc_card.setImageResource(R.drawable.family_card);
                typemoney = 1;
            }
        });

        azc_card = aactivity.findViewById(R.id.azc_card);
        azc_card.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc_cash.setImageResource(R.drawable.family_cashn);
                azc_card.setImageResource(R.drawable.family_carda);
                typemoney = 2;
            }
        });

        azcpay = aactivity.findViewById(R.id.azcpay);
        azcpay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                if(fuelstation_active == 0)
                {
                    NvEventQueueActivity.getInstance().showNotification(2, "Выберите тип топлива", 2, "", "");
                    return;
                }
                if(typemoney == 0)
                {
                    NvEventQueueActivity.getInstance().showNotification(2, "Выберите способ оплаты", 2, "", "");
                    return;
                }
                if(fielstation_progress <= 0)
                {
                    NvEventQueueActivity.getInstance().showNotification(2, "Укажите количество литров", 2, "", "");
                    return;
                }

                view.startAnimation(AnimationUtils.loadAnimation(aactivity, R.anim.button_click));
                HideFuelStation(fuelstation_active, fielstation_progress, typemoney);
            }
        });

        priceazc = aactivity.findViewById(R.id.priceazc);
        litrash = aactivity.findViewById(R.id.litrash);

        fuelstation_bar = aactivity.findViewById(R.id.fuelstation_bar);
        fuelstation_bar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                fielstation_progress = progress;
                fuelprice = fuelprice1 * progress;
                String strpriceinfo = String.format("%s", fuelprice);
                String strliterinfo = String.format("%s", progress);
                priceazc.setText(String.valueOf(strpriceinfo));
                litrash.setText(String.valueOf(strliterinfo));
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {}

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {}
        });


        closeazc = aactivity.findViewById(R.id.closeazc);
        closeazc.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hide();
            }
        });

        azc92 = aactivity.findViewById(R.id.azc92);
        azc92.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc80.setImageResource(R.drawable.azcneactive);
                azc98.setImageResource(R.drawable.azcneactive);
                azc95.setImageResource(R.drawable.azcneactive);
                azc92.setImageResource(R.drawable.azcactive);
                fuelstation_active = 2;
            }
        });
        azc95 = aactivity.findViewById(R.id.azc95);
        azc95.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc80.setImageResource(R.drawable.azcneactive);
                azc98.setImageResource(R.drawable.azcneactive);
                azc95.setImageResource(R.drawable.azcactive);
                azc92.setImageResource(R.drawable.azcneactive);
                fuelstation_active = 3;
            }
        });
        azc98 = aactivity.findViewById(R.id.azc98);
        azc98.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc80.setImageResource(R.drawable.azcneactive);
                azc98.setImageResource(R.drawable.azcactive);
                azc95.setImageResource(R.drawable.azcneactive);
                azc92.setImageResource(R.drawable.azcneactive);
                fuelstation_active = 4;
            }
        });
        azc80 = aactivity.findViewById(R.id.azc80);
        azc80.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                azc80.setImageResource(R.drawable.azcactive);
                azc98.setImageResource(R.drawable.azcneactive);
                azc95.setImageResource(R.drawable.azcneactive);
                azc92.setImageResource(R.drawable.azcneactive);
                fuelstation_active = 1;
            }
        });


        Utils.HideLayout(constraintLayout, false);
    }



    public void show() {
        Utils.ShowLayout(constraintLayout, true);
        NvEventQueueActivity.getInstance().hideHud();
    }

    public void hide() {
        Utils.HideLayout(constraintLayout, true);
        NvEventQueueActivity.getInstance().showHud();
    }

    public void HideFuelStation(int typefuel, int literfuel, int typemoney) {
        NvEventQueueActivity.getInstance().onFuelStationClick(typefuel, literfuel, typemoney);
        Utils.HideLayout(constraintLayout, true);
        NvEventQueueActivity.getInstance().showHud();
        fuelstation_active = 0;
        typemoney = 0;
    }
}

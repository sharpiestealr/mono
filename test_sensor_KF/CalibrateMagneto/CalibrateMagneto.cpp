//TODO: ABLE TO DISABLE CALIBRATION UPDATE MORE EFFICIENT
//TODO: CHANGE AVERAGE DUE TO NEW EXTREME FOUND
#include "CalibrateMagneto.h"

CalibrateMagneto::CalibrateMagneto( void ) {
    measurementNumber = 0;
    this->setAbsGain(0.1);
    this->setRelGain(0.05);
};


void CalibrateMagneto::setAbsGain( float gain ) {
    if (gain>=0)
        abs_gain=gain;
}

void CalibrateMagneto::setRelGain( float gain ) {
    if (gain>=0 && gain<=1)
        rel_gain=gain;
}

void CalibrateMagneto::setExtremes(float *min, float *max) {
    x_min=min[0];
    y_min=min[1];
    z_min=min[2];
    x_max=max[0];
    y_max=max[1];
    z_max=max[2];

    //Disable initial points
    measurementNumber = INITIAL_POINTS+1;
}

void CalibrateMagneto::getExtremes(float *min, float *max) {
    min[0]=x_min;
    min[1]=y_min;
    min[2]=z_min;
    max[0]=x_max;
    max[1]=y_max;
    max[2]=z_max;

}

void CalibrateMagneto::run(float *input, float *output) {
    float x_avg, y_avg, z_avg, x_range, y_range, z_range;
    bool x_zero, y_zero, z_zero;
    float temp;


    if (measurementNumber==0) {         //Initial measurement just presets everything
        x_min=input[0];
        x_max=input[0];
        y_min=input[1];
        y_max=input[1];
        z_min=input[2];
        z_max=input[2];
        measurementNumber++;
        output[0] = input[0];
        output[1] = input[1];
        output[2] = input[2];
    } else {
        x_avg = (x_min+x_max)/2;
        y_avg = (y_min+y_max)/2;
        z_avg = (z_min+z_max)/2;


        if (measurementNumber < INITIAL_POINTS) {        //No abs gain used, no rel gain used, no range used
            if (input[0]<x_min)
                x_min = input[0];
            else if (input[0]>x_max)
                x_max = input[0];

            if (input[1]<y_min)
                y_min = input[1];
            else if (input[1]>y_max)
                y_max = input[1];

            if (input[2]<z_min)
                z_min = input[2];
            else if (input[2]>z_max)
                z_max = input[2];

            //Return inputs, since filter is still bad
            output[0] = input[0];
            output[1] = input[1];
            output[2] = input[2];

            measurementNumber++;
        } else {                 //Now we should have enough data
            x_range=x_max-x_min;
            y_range=y_max-y_min;
            z_range=z_max-z_min;

            //If measurement is a new extreme:
            if (input[0]<x_min) {
                temp = rel_gain*(x_min - input[0]);
                if (temp > abs_gain*(x_max-x_min))
                    temp = abs_gain*(x_max-x_min);
                x_min = x_min - temp;
            } else if (input[0]>x_max) {
                temp = rel_gain*(input[0] - x_max);
                if (temp > abs_gain*(x_max-x_min))
                    temp = abs_gain*(x_max-x_min);
                x_max = x_max + temp;
            }

            if (input[1]<y_min) {
                temp = rel_gain*(y_min - input[1]);
                if (temp > abs_gain*(y_max-y_min))
                    temp = abs_gain*(y_max-y_min);
                y_min = y_min - temp;
            } else if (input[1]>y_max) {
                temp = rel_gain*(input[1]-y_max);
                if (temp > abs_gain*(y_max-y_min))
                    temp = abs_gain*(y_max-y_min);
                y_max = y_max + temp;
            }

            if (input[2]<z_min) {
                temp = rel_gain*(z_min - input[2]);
                if (temp > abs_gain*(z_max-z_min))
                    temp = abs_gain*(z_max-z_min);
                z_min = z_min - temp;
            } else if (input[2]>z_max) {
                temp = rel_gain*(input[2]-z_max );
                if (temp > abs_gain*(z_max-z_min))
                    temp = abs_gain*(z_max-z_min);
                z_max = z_max + temp;
            }

            //If measurement is near the zero of the other two axes
            x_zero=false;
            y_zero=false;
            z_zero=false;
            if (abs( input[0] - x_avg ) < (x_range * ZERO_RANGE))
                x_zero=true;
            if (abs( input[1] - y_avg ) < (y_range * ZERO_RANGE))
                y_zero=true;
            if (abs( input[2] - z_avg ) < (z_range * ZERO_RANGE))
                z_zero=true;


            if (x_zero && y_zero) {
                if (input[2]>z_avg) {
                    temp = rel_gain*(input[2] - z_max);
                    if (abs(temp) > abs_gain*(z_max-z_min))
                        temp = sign(temp)*abs_gain*(z_max-z_min);
                    z_max = z_max + temp;
                }
                if (input[2]<z_avg) {
                    temp = rel_gain*(z_min - input[2]);
                    if (abs(temp) > abs_gain*(z_max-z_min))
                        temp = sign(temp)*abs_gain*(z_max-z_min);
                    z_min = z_min - temp;
                }
            }

            if (x_zero && z_zero) {
                if (input[1]>y_avg) {
                    temp = rel_gain*(input[1] - y_max);
                    if (abs(temp) > abs_gain*(y_max-y_min))
                        temp = sign(temp)*abs_gain*(y_max-y_min);
                    y_max = y_max + temp;
                }
                if (input[1]<y_avg) {
                    temp = rel_gain*(y_min - input[1]);
                    if (abs(temp) > abs_gain*(y_max-y_min))
                        temp = sign(temp)*abs_gain*(y_max-y_min);
                    y_min = y_min - temp;
                }
            }

            if (y_zero && z_zero) {
                if (input[0]>x_avg) {
                    temp = rel_gain*(input[0] - x_max);
                    if (abs(temp) > abs_gain*(x_max-x_min))
                        temp = sign(temp)*abs_gain*(x_max-x_min);
                    x_max = x_max + temp;
                }
                if (input[0]<x_avg) {
                    temp = rel_gain*(x_min - input[0]);
                    if (abs(temp) > abs_gain*(x_max-x_min))
                        temp = sign(temp)*abs_gain*(x_max-x_min);
                    x_min = x_min - temp;
                }
            }

            //And now the actual filter part:
            output[0] = 2* (input[0] - x_avg)/x_range;
            output[1] = 2* (input[1] - y_avg)/y_range;
            output[2] = 2* (input[2] - z_avg)/z_range;


        }
    }
}



float CalibrateMagneto::sign(float input) {
    if (input<0)
        return -1.0;
    else
        return 1.0;
}
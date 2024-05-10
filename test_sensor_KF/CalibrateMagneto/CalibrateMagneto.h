/* Really no one cares about copyright notices */

#ifndef CALIBRATEMAGNETO_H
#define CALIBRATEMAGNETO_H

/**
 * Includes
 */
#include "mbed.h"
#define INITIAL_POINTS          100
#define ZERO_RANGE              0.15


/** Class to automatically calibrate magnetometers
*
*/
class CalibrateMagneto {

public:

    /** Constructor
    *
    */
    CalibrateMagneto( void );
    
    /** Sets the maximum absolute gain
    *
    * New data changes the calibration values, this setting limits the maximum rate this can change (constructor defaults it to 0.01)
    * The first few datapoints (defined by INITIAL_POINTS) absGain (and relGain) is disabled to make sure the filter can work. If filter coefficients are manually added abs_gain wont be disabled.
    * If absGain is set above 1000, it is also disabled.
    *
    * @param gain - a float that sets the maximum absolute gain, needs to be positive (zero turns of autocalibration)
    */
    void setAbsGain( float gain );
    
    /** Sets the relative gain
    *
    * New data changes the calibration values, this setting changes how fast the calibration values will converge to their new value (constructor defaults it to 0.01). 
    *
    * @param gain - a float that sets the maximum absolute gain, needs to be positive, smaller than one
    */
    void setRelGain( float gain );

    /** The calibration works by calculating the extreme values for the axes, this function allows you to manually set them
    *
    * @param min - pointer to a float array with length three, which store the three minimum values (X-Y-Z)
    * @param max - pointer to a float array with length three, which store the three maximum values (X-Y-Z)
    */
    void setExtremes(float *min, float *max);
    
    /** The calibration works by calculating the extreme values for the axes, this function allows you to get them
    *
    * Doing calibration everytime from zero is not required normally, so it is useful to at the end of your program get these values,
    * and set them next time you run the calibration. Storing them can for example be done on the local filesystem.
    *
    * @param min - pointer to a float array with length three, to store the three minimum values (X-Y-Z)
    * @param max - pointer to a float array with length three, to store the three maximum values (X-Y-Z)
    */
    void getExtremes(float *min, float *max);
    
    /**
    * Runs the filter, takes the latest magnetometric inputs, and calculates the scaled/shifted outputs. Also updates the filter
    *
    * To prevent filter from updating, set relGain or absGain to zero.
    *
    * @param input, float array with length three which contains the new measurement data (X-Y-Z)
    * @param output, float array with length three which contains the output data (X-Y-Z). Scaled to have on average a length of one. 
    */    
    void run(float *input, float *output);
    
private:
    float x_min, x_max, y_min, y_max, z_min, z_max;
    
    float abs_gain, rel_gain;
    
    int measurementNumber;
    
    float sign(float input);

};

#endif
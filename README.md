# P-wave_detection_ECG
Detection of P-waves in ECG signal, given the annotations of QRS peaks.

The file 'sel33.dat' conteins the ECG signal, while 'sel33.q1c' conteins manual annotations of the first and the last index of several P waves, QRS complexes and T waves.
QRS peaks are annotated as "N", while P waves as "p".

This algorithm removed QRS peaks and replace them with isoelectric line; the resultant signal is filtered with a band-pass filter (3Hz - 11Hz).

Given the annotations is computed the period of research of P-wave, as (2/9)*RR +250ms, where RR is the  mean distance R-R in the present annotations.
Given the filtered signals and the period of research of P-wave, P-waves are detected, and it's computed the synchronized mean.

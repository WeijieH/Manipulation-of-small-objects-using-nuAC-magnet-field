figure
subplot(3,1,1);
trajectory( Result, 4, 1.1, true);
trajectory( Result, 5, 1.1, true);
trajectory( Result, 6, 1.1, true);
trajectory( Result, 8, 1.1, true);
trajectory( Result, 10, 1.1, true);
trajectory( Result, 11, 1.1, true);
trajectory( Result, 15, 1.1, true);
trajectory( Result, 16, 1.1, true);
subplot(3,1,2);
load('02mgml_10Hz_R100fps_NS_Result.mat')
trajectory( Result, 4, 1.1, true);
trajectory( Result, 5, 1.1, true);
trajectory( Result, 7, 1.1, true);
trajectory( Result, 3, 1.1, true);
trajectory( Result, 940, 1.1, true);
trajectory( Result, 149, 1.1, true);
trajectory( Result, 6, 1.1, true);
trajectory( Result, 107, 1.1, true);
subplot(3,1,3);
load('02mgml_10Hz_R100fps_NN_Result.mat')
trajectory( Result, 2, 1.1, true);
trajectory( Result, 4, 1.1, true);
trajectory( Result, 5, 1.1, true);
trajectory( Result, 6, 1.1, true);
trajectory( Result, 9, 1.1, true);
trajectory( Result, 1751, 1.1, true);
trajectory( Result, 2311, 1.1, true);
trajectory( Result, 3785, 1.1, true);
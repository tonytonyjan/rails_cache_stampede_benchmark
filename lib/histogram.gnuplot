set title custom_title
set terminal png font 'Noto Sans' size 1280,960
set boxwidth 0.8
set style fill solid
set style histogram rowstacked
set style data histograms
set xlabel 'Stampede size'
set xrange noextend
set ylabel 'Number of occurrences'
plot x_fetch_path title 'x\_fetch', \
     fetch_path title 'fetch'

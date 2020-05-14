# Geometric Anomalies

<h3> Project founder: </h3> Bernadette J. Stolz (for more information, see <a href="https://www.maths.ox.ac.uk/people/bernadette.stolz"> here</a>.)
  
<h3> Description </h3>
  
This repository was created for Matlab scripts used in the manuscript <a href="#GA">[1]</a>.
The manuscript can be found <a href="https://arxiv.org/pdf/1908.09397.pdf"> here</a>. 

<h3> Matlab scripts </h3>

The scripts used to analyse the Cyclo-octane data set and the Henneberg surface data set are:

<ul>

<p>
<li>
SingularitiesCycloOctane.m
  
<p>
<li>
SingularitiesHennebergSurface.m
  
</ul>

We further include the script

<ul>

<p>
<li>

PHvsMWComparison.m

</ul>

which compares our local persistent homology method to the local PCA approach used by Martin et al. <a href="#Martin2010">[2]</a>.


<h3> Data sets </h3>

The cyclo-octane dataset was introduced by Martin et al. <a href="#Martin2010">[2]</a> and consists of 6040 points in 24 dimensions. This data set is publicly available as part of the <a href="http://appliedtopology.github.io/javaplex/"> javaPlex software package</a>. The Henneberg surface dataset was kindly provided by Martin et al. <a href="#Martin2011">[3]</a> and it consists of 5456 points sampled from the Henneberg surface in 3 dimensions.

<ul>

<p>
<li>

pointsCycloOctane.mat

<p>
<li>

henneberg_point_cloud.mat

</ul>


<h3> External software necessary to run the scripts </h3>

We include all functions, other sources of software and directories used by the scripts.

<ul>
<p>
<li>
ripser: We use the software <a href="https://github.com/Ripser/ripser"> ripser</a> by Ulrich Bauer. 
Note that we added the directories 'input' and 'output' to the ripser folder that are required by our script.

<p>
<li>
plot_barcodes.m: We use this Matlab function written by Nina Otter. It is available at her <a href="https://github.com/n-otter/PH-roadmap"> repository </a>.

</ul>

<h3> References </h3>
<a name="GA">[1]</a> Geometric anomaly detection in data. BJ Stolz, J Tanner, HA Harrington, V Nanda, <i>arXiv preprint arXiv: 1908.09397</i>, 2019.

<a name="Martin2010">[2]</a> Topology of cyclo-octane energy landscape. S Martin, A Thompson, EA Coutsias, J-P Watson, <i>The Journal of Chemical Physics</i>, 2010, <b>132</b>:23.

<a name="Martin2011">[3]</a> Non-manifold surface reconstruction from high-dimensional point cloud data. S Martin, J-P Watson, <i>Computational Geometry</i>, 2011, <b>44</b>.

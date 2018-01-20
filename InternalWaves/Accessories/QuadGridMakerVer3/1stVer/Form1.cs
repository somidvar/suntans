using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace _1stVer
{
    public partial class QuadGridBathymetryInitiation : Form
    {
        List<double> XData = new List<double>();
        List<double> YData = new List<double>();
        List<double> ZData = new List<double>();
        bool XMeshControl, YMeshControl, GridControl, BoundaryControl, BathymetryControl;
        double[,] VerticalEdges, HorizontalEdges;
        double[,] cells;
        double A, B, C, D;

        public QuadGridBathymetryInitiation()
        {
            InitializeComponent();
            XMeshControl = YMeshControl = GridControl = BoundaryControl = BathymetryControl = false;

            FirstRun();

        }
        private void FirstRun()
        {
            XStartingLocationTextbox.Text = "0";
            XEndingLocationTextbox.Text = "70000";
            XSteppingMethodCombo.SelectedIndex = 1;
            XCellNumberTextbox.Text = "700";

            YStartingLocationTextbox.Text = "0";
            YEndingLocationTextbox.Text = "100";
            YSteppingMethodCombo.SelectedIndex = 1;
            YCellNumberTextbox.Text = "1";
            ATextbox.Text = "1";
            BTextbox.Text = "1";
            CTextbox.Text = "1";
            DTextbox.Text = "1";
            ResultAdressTextbox.Text = "D:\\";
            BathymetryCombo.SelectedIndex = 0;
            BottomBoundaryCombo.SelectedIndex = 1;
            TopBoundaryCombo.SelectedIndex = 1;
            RightBoundaryCombo.SelectedIndex = 2;
            LeftBoundaryCombo.SelectedIndex = 1;
        }

        private void XSteppingMethodCombo_SelectionChangeCommitted(object sender, EventArgs e)
        {
            //0 is Linear and 1 is constant
            if (XSteppingMethodCombo.SelectedIndex == 0)
            {
                XSteppingRatioTextbox.Enabled = true;
                XStartingValueTextbox.Enabled = true;
                XCellNumberTextbox.Enabled = false;
            }
            if (XSteppingMethodCombo.SelectedIndex == 1)
            {
                XSteppingRatioTextbox.Enabled = false;
                XStartingValueTextbox.Enabled = false;
                XCellNumberTextbox.Enabled = true;
            }
        }
        private void YSteppingMethodCombo_SelectionChangeCommitted(object sender, EventArgs e)
        {
            //0 is Linear and 1 is constant
            if (YSteppingMethodCombo.SelectedIndex == 0)
            {
                YSteppingRatioTextbox.Enabled = true;
                YStartingValueTextbox.Enabled = true;
                YCellNumberTextbox.Enabled = false;
            }
            if (YSteppingMethodCombo.SelectedIndex == 1)
            {
                YSteppingRatioTextbox.Enabled = false;
                YStartingValueTextbox.Enabled = false;
                YCellNumberTextbox.Enabled = true;
            }
        }

        private void XAddButton_Click(object sender, EventArgs e)
        {
            double XStartingLocationDouble, XEndingLocationDouble, XSteppingRatioDouble, XStartingValueDouble;
            XStartingLocationDouble = XEndingLocationDouble = XSteppingRatioDouble = XStartingValueDouble = 0;
            int XCellNUmberInt = 0;
            try
            {
                XStartingLocationDouble = Convert.ToDouble(XStartingLocationTextbox.Text);
                XEndingLocationDouble = Convert.ToDouble(XEndingLocationTextbox.Text);
                if (XSteppingMethodCombo.SelectedIndex == 0)
                {
                    XSteppingRatioDouble = Convert.ToDouble(XSteppingRatioTextbox.Text);
                    XStartingValueDouble = Convert.ToDouble(XStartingValueTextbox.Text);
                }
                if (XSteppingMethodCombo.SelectedIndex == 1)
                    XCellNUmberInt = Convert.ToInt32(XCellNumberTextbox.Text);
            }
            catch (Exception Exp2)
            {
                MessageBox.Show(string.Format("{0}/r/n{1}", "The X direction input format is not correct. Please make sure you have entered them as number.", Exp2.Message.ToString()), "X Direction Input Format", MessageBoxButtons.OK, MessageBoxIcon.Error);

            }
            // Making X Grid
            if (XSteppingMethodCombo.SelectedIndex == 1)
            {
                for (int counter = 0; counter <= XCellNUmberInt; counter++)
                    XData.Add(XStartingLocationDouble + counter * 1.0 * (XEndingLocationDouble - XStartingLocationDouble) / XCellNUmberInt);
            }
            if (XSteppingMethodCombo.SelectedIndex == 0)
            {
                double counter = 0;
                XData.Add(XStartingLocationDouble);
                while (true)
                {
                    double Temp = XStartingLocationDouble + XStartingValueDouble * Math.Pow(XSteppingRatioDouble, counter);
                    if (Temp <= XEndingLocationDouble)
                        XData.Add(Temp);
                    else
                    {
                        XData.Add(XEndingLocationDouble);
                        break;
                    }
                    counter++;
                }
            }
            XMeshControl = true;
        }

        private void YAddButton_Click(object sender, EventArgs e)
        {
            double YStartingLocationDouble, YEndingLocationDouble, YSteppingRatioDouble, YStartingValueDouble;
            YStartingLocationDouble = YEndingLocationDouble = YSteppingRatioDouble = YStartingValueDouble = 0;
            int YCellNUmberInt = 0;
            try
            {
                YStartingLocationDouble = Convert.ToDouble(YStartingLocationTextbox.Text);
                YEndingLocationDouble = Convert.ToDouble(YEndingLocationTextbox.Text);
                if (YSteppingMethodCombo.SelectedIndex == 0)
                {
                    YSteppingRatioDouble = Convert.ToDouble(YSteppingRatioTextbox.Text);
                    YStartingValueDouble = Convert.ToDouble(YStartingValueTextbox.Text);
                }
                if (YSteppingMethodCombo.SelectedIndex == 1)
                    YCellNUmberInt = Convert.ToInt32(YCellNumberTextbox.Text);
            }
            catch (Exception Exp2)
            {
                MessageBox.Show(string.Format("{0}/r/n{1}", "The Y direction input format is not correct. Please make sure you have entered them as number.", Exp2.Message.ToString()), "Y Direction Input Format", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            // Making Y Grid
            if (YSteppingMethodCombo.SelectedIndex == 1)
            {
                for (int counter = 0; counter <= YCellNUmberInt; counter++)
                    YData.Add(YStartingLocationDouble + counter * 1.0 * (YEndingLocationDouble - YStartingLocationDouble) / YCellNUmberInt);
            }
            if (YSteppingMethodCombo.SelectedIndex == 0)
            {
                double counter = 0;
                YData.Add(YStartingLocationDouble);
                while (true)
                {
                    double Temp = YStartingLocationDouble + YStartingValueDouble * Math.Pow(YSteppingRatioDouble, counter);
                    if (Temp <= YEndingLocationDouble)
                        YData.Add(Temp);
                    else
                    {
                        YData.Add(YEndingLocationDouble);
                        break;
                    }
                    counter++;
                }
            }
            YMeshControl = true;
        }
        private void MakingGridButt_Click(object sender, EventArgs e)
        {
            if (YMeshControl && XMeshControl)
                MakingGrid();
            if (!XMeshControl || !YMeshControl)
            {
                MessageBox.Show("X Grid or Y Grid has not been successfully made, please rerun the program and makes sure you press add for each direction", "Griding Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }
        private void MakingGrid()
        {
            //First two columns are rectangle centers, the very next 4 ones are node indices of each rectangle and the last 4 ones are each cell neighbours and the last one is the depth of Voronoi point.
            //Node indices have been numbered respectively: Left Top, Right Top, Right Bottom, Left Bottom
            //Neighbors have been numbered respectively: Bottom, Right, top, Left and -1 shows no neighbour
            cells = new double[(XData.Count - 1) * (YData.Count - 1), 11];
            for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                {
                    cells[counter2 + counter1 * (XData.Count - 1), 0] = (XData[counter2] + XData[counter2 + 1]) / 2;
                    cells[counter2 + counter1 * (XData.Count - 1), 1] = (YData[counter1] + YData[counter1 + 1]) / 2;
                    cells[counter2 + counter1 * (XData.Count - 1), 2] = XData.Count * (counter1 + 1) + counter2;
                    cells[counter2 + counter1 * (XData.Count - 1), 3] = XData.Count * (counter1 + 1) + counter2 + 1;
                    cells[counter2 + counter1 * (XData.Count - 1), 4] = XData.Count * counter1 + counter2 + 1;
                    cells[counter2 + counter1 * (XData.Count - 1), 5] = XData.Count * counter1 + counter2;
                    if (counter1 != 0)
                        cells[counter2 + counter1 * (XData.Count - 1), 6] = (XData.Count - 1) * (counter1 - 1) + (counter2 + 0);
                    else
                        cells[counter2 + counter1 * (XData.Count - 1), 6] = -1;
                    if (counter2 != XData.Count - 2)
                        cells[counter2 + counter1 * (XData.Count - 1), 7] = (XData.Count - 1) * (counter1 + 0) + (counter2 + 1);
                    else
                        cells[counter2 + counter1 * (XData.Count - 1), 7] = -1;
                    if (counter1 != YData.Count - 2)
                        cells[counter2 + counter1 * (XData.Count - 1), 8] = (XData.Count - 1) * (counter1 + 1) + (counter2 + 0);
                    else
                        cells[counter2 + counter1 * (XData.Count - 1), 8] = -1;
                    if (counter2 != 0)
                        cells[counter2 + counter1 * (XData.Count - 1), 9] = (XData.Count - 1) * (counter1 + 0) + (counter2 - 1);
                    else
                        cells[counter2 + counter1 * (XData.Count - 1), 9] = -1;
                }
            }
            //The first column is the number of element face, the 2nd and 3rd columns are start and end of each edge, the 4th column is the boundary condition and the last two ones are Voronoi on either side of the edge. -1 means there is no point
            //For VerticalEdges: Down, Up,-, Right, Left
            //For HorizontalEdges: Right, Left, -, Down, Up
            VerticalEdges = new double[XData.Count * (YData.Count - 1), 5];
            for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count; counter2++)
                {
                    VerticalEdges[counter2 + counter1 * XData.Count, 0] = counter2 + (counter1 + 0) * XData.Count;
                    VerticalEdges[counter2 + counter1 * XData.Count, 1] = counter2 + (counter1 + 1) * XData.Count;
                    if (counter2 == 0)
                        VerticalEdges[counter2 + counter1 * XData.Count, 2] = Convert.ToInt16(LeftBoundaryCombo.SelectedIndex);
                    else if (counter2 == XData.Count - 1)
                        VerticalEdges[counter2 + counter1 * XData.Count, 2] = Convert.ToInt16(RightBoundaryCombo.SelectedIndex);
                    else
                        VerticalEdges[counter2 + counter1 * XData.Count, 2] = 0;
                    if (counter2 != XData.Count - 1)
                        VerticalEdges[counter2 + counter1 * XData.Count, 3] = counter2 + counter1 * (XData.Count - 1);
                    else
                        VerticalEdges[counter2 + counter1 * XData.Count, 3] = -1;
                    if (counter2 != 0)
                        VerticalEdges[counter2 + counter1 * XData.Count, 4] = counter2 + counter1 * (XData.Count - 1) - 1;
                    else
                        VerticalEdges[counter2 + counter1 * XData.Count, 4] = -1;
                }
            }
            HorizontalEdges = new double[(XData.Count - 1) * YData.Count, 5];
            for (int counter1 = 0; counter1 < YData.Count; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                {
                    HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 0] = (counter2 + 1) + counter1 * XData.Count;
                    HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 1] = (counter2 + 0) + counter1 * XData.Count;
                    if (counter1 == 0)
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 2] = Convert.ToInt16(BottomBoundaryCombo.SelectedIndex);
                    else if (counter1 == YData.Count - 1)
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 2] = Convert.ToInt16(TopBoundaryCombo.SelectedIndex);
                    else
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 2] = 0;
                    if (counter1 != 0)
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 3] = counter2 + (counter1 - 1) * (XData.Count - 1);
                    else
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 3] = -1;
                    if (counter1 != YData.Count - 1)
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 4] = counter2 + (counter1 - 0) * (XData.Count - 1);
                    else
                        HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 4] = -1;
                }
            }
            GridControl = true;
        }

        private void BathymetryCombo_SelectedIndexChanged(object sender, EventArgs e)
        {
            //In this program it is assumed that tha shore is align the Y direction at X=0
            // 0 is Line and 1 is Hyperbolic Tangenet
            if (BathymetryCombo.SelectedIndex == 0)
                BathymetryFormula.Text = "A*X^3+B*X^2+C*X+D";
            if (BathymetryCombo.SelectedIndex == 1)
                BathymetryFormula.Text = "A*Tanh(B*X+C)+D";
        }

        private void CreateButton_Click(object sender, EventArgs e)
        {
            if (!GridControl)
            {
                MessageBox.Show("Grid has not been successfully made, please rerun the program and makes sure you push the make grid button after adding X and Y dirctions", "Grid Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            try
            {
                A = Convert.ToDouble(ATextbox.Text);
                B = Convert.ToDouble(BTextbox.Text);
                C = Convert.ToDouble(CTextbox.Text);
                D = Convert.ToDouble(DTextbox.Text);
            }
            catch (Exception Exp1)
            {
                MessageBox.Show(string.Format("{0}/r/n{1}", "The Bathymetry input format is not correct. Please make sure you have entered them as number.", Exp1.Message.ToString()), "Bathymetry Input Format", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            if (BathymetryCombo.SelectedIndex == 0)
            {
                for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
                {
                    for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                        cells[counter2 + counter1 * (XData.Count - 1), 10] = A * Math.Pow(cells[counter2 + counter1 * (XData.Count - 1), 0], 3) + B * Math.Pow(cells[counter2 + counter1 * (XData.Count - 1), 0], 2) + C * Math.Pow(cells[counter2 + counter1 * (XData.Count - 1), 0], 3) + D;
                }
                BathymetryControl = true;
            }
            if (BathymetryCombo.SelectedIndex == 1)
            {

                for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
                {
                    for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                        cells[counter2 + counter1 * (XData.Count - 1), 10] = A * Math.Tanh(B * (cells[counter2 + counter1 * (XData.Count - 1), 0]) + C) + D;
                }
                BathymetryControl = true;
            }
            if (!BathymetryControl)
            {
                MessageBox.Show("Bathymetry has not been successfully made, please check the parameters and type", "Bathymetry Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (BottomBoundaryCombo.SelectedIndex != -1 && TopBoundaryCombo.SelectedIndex != -1 && RightBoundaryCombo.SelectedIndex != -1 && LeftBoundaryCombo.SelectedIndex != -1)
                BoundaryControl = true;
            if (!BoundaryControl)
            {
                MessageBox.Show("Boundary conditions have not been successfully made, please rerun the program and makes sure you press add for each direction", "Boundary Condition Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            WritingFunction();
        }
        private void BrowseButton_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog ResultBrowser = new FolderBrowserDialog();
            ResultBrowser.ShowDialog();
            ResultBrowser.ShowNewFolderButton = true;
            ResultAdressTextbox.Text = ResultBrowser.SelectedPath;
        }
        private void WritingFunction()
        {
            StreamWriter PointWriter;
            StreamWriter CellWriter;
            StreamWriter EdgeWriter;
            StreamWriter BathymetryWriter;
            try
            {
                PointWriter = new StreamWriter(ResultAdressTextbox.Text + "points.dat");
                CellWriter = new StreamWriter(ResultAdressTextbox.Text + "cells.dat");
                EdgeWriter = new StreamWriter(ResultAdressTextbox.Text + "edges.dat");
                BathymetryWriter = new StreamWriter(ResultAdressTextbox.Text + "depth.dat");

            }
            catch (Exception Exp1)
            {
                MessageBox.Show(string.Format("{0}/r/n{1}", "There is an error in writing the result file", Exp1.Message.ToString()), "Writing Reult File", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
            //Writing points.dat
            //The 1st, 2nd and 3rd columns are X, Y, Point number
            int counter = 0;
            foreach (double YDirection in YData)
            {
                foreach (double XDirection in XData)
                {
                    string Temporary = string.Format("{0}\t{1}\t{2}", XDirection, YDirection, counter);
                    PointWriter.Write(Temporary);
                    PointWriter.Write("\n");
                    /*
                    PointWriter.Write(XDirection);
                    PointWriter.Write("    ");
                    PointWriter.Write(YDirection);
                    PointWriter.Write("    ");
                    PointWriter.WriteLine(counter);
                     */
                    counter++;
                }
            }
            PointWriter.Close();
            //Writing cell.dat
            for (int counter1 = 0; counter1 < (XData.Count - 1) * (YData.Count - 1); counter1++)
            {
                string Temporary = string.Format("4\t{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}", cells[counter1, 0], cells[counter1, 1], cells[counter1, 2], cells[counter1, 3], cells[counter1, 4], cells[counter1, 5], cells[counter1, 6], cells[counter1, 7], cells[counter1, 8], cells[counter1, 9]);
                CellWriter.Write(Temporary);
                CellWriter.Write("\n");
                /*
                CellWriter.Write("4\t");
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 0]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 1]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 2]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 3]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 4]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 5]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 6]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 7]);
                CellWriter.Write("   ");
                CellWriter.Write(cells[counter1, 8]);
                CellWriter.Write("   ");
                CellWriter.WriteLine(cells[counter1, 9]);
                 */
            }
            CellWriter.Close();
            //Writing edges.dat
            for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count; counter2++)
                {
                    //Please be advised about the reverse order of 3rd and 4th columns
                    //string Temporary = string.Format("{0}\t{1}\t{2}\t{4}\t{3}", VerticalEdges[counter2 + counter1 * XData.Count, 0], VerticalEdges[counter2 + counter1 * XData.Count, 1], VerticalEdges[counter2 + counter1 * XData.Count, 2], VerticalEdges[counter2 + counter1 * XData.Count, 3], VerticalEdges[counter2 + counter1 * XData.Count, 4]);
                    string Temporary = string.Format("{0}\t{1}\t{2}\t{4}\t{3}", VerticalEdges[counter2 + counter1 * XData.Count, 0], VerticalEdges[counter2 + counter1 * XData.Count, 1], VerticalEdges[counter2 + counter1 * XData.Count, 2], VerticalEdges[counter2 + counter1 * XData.Count, 3], VerticalEdges[counter2 + counter1 * XData.Count, 4]);
                    EdgeWriter.Write(Temporary);
                    EdgeWriter.Write("\n");
                    
                    /*
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XData.Count, 0]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XData.Count, 1]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XData.Count, 2]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XData.Count, 3]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.WriteLine(VerticalEdges[counter2 + counter1 * XData.Count, 4]);
                     */
                }
            }
            for (int counter1 = 0; counter1 < YData.Count; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                {
                    //Please be advised about the reverse order of 3rd and 4th columns
                    string Temporary = string.Format("{0}\t{1}\t{2}\t{3}\t{4}", HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 0], HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 1], HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 2], HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 3], HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 4]);
                    EdgeWriter.Write(Temporary);
                    EdgeWriter.Write("\n");
                    /*
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 0]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 1]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 2]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 3]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.WriteLine(HorizontalEdges[counter2 + counter1 * (XData.Count - 1), 4]);
                     */
                }
            }
            EdgeWriter.Close();
            //Writing depth.dat
            for (int counter1 = 0; counter1 < YData.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XData.Count - 1; counter2++)
                {
                    string Temporary = string.Format("{0}\t{1}\t{2}", cells[counter2 + counter1 * (XData.Count - 1), 0], cells[counter2 + counter1 * (XData.Count - 1), 1], cells[counter2 + counter1 * (XData.Count - 1), 10]);
                    BathymetryWriter.Write(Temporary);
                    BathymetryWriter.Write("\n");
                    /*
                    BathymetryWriter.Write(cells[counter2 + counter1 * (XData.Count - 1), 0]);
                    BathymetryWriter.Write("    ");
                    BathymetryWriter.Write(cells[counter2 + counter1 * (XData.Count - 1), 1]);
                    BathymetryWriter.Write("    ");
                    BathymetryWriter.WriteLine(cells[counter2 + counter1 * (XData.Count - 1), 10]);
                     */
                }
            }
            BathymetryWriter.Close();
            MessageBox.Show("The grid and bathymetry have been made successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }
    }
}

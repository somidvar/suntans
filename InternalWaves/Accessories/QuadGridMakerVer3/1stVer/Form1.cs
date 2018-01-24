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
        List<double> XDataTemporary = new List<double>();
        List<double> YDataTemporary = new List<double>();
        List<double> XDataFinal = new List<double>();
        List<double> YDataFinal = new List<double>();
        bool XMeshControl, YMeshControl, GridControl, BoundaryControl;
        double[,] VerticalEdges, HorizontalEdges;
        double[,] cells;

        public QuadGridBathymetryInitiation()
        {
            InitializeComponent();
            XMeshControl = YMeshControl = GridControl = BoundaryControl = false;

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
            ResultAdressTextbox.Text = "D:\\";
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
                XStepRatioTextbox.Enabled = true;
                XInitialStepTextbox.Enabled = true;
                XCellNumberTextbox.Enabled = false;
            }
            if (XSteppingMethodCombo.SelectedIndex == 1)
            {
                XStepRatioTextbox.Enabled = false;
                XInitialStepTextbox.Enabled = false;
                XCellNumberTextbox.Enabled = true;
            }
        }
        private void YSteppingMethodCombo_SelectionChangeCommitted(object sender, EventArgs e)
        {
            //0 is Linear and 1 is constant
            if (YSteppingMethodCombo.SelectedIndex == 0)
            {
                YStepRatioTextbox.Enabled = true;
                YInitialStepTextbox.Enabled = true;
                YCellNumberTextbox.Enabled = false;
            }
            if (YSteppingMethodCombo.SelectedIndex == 1)
            {
                YStepRatioTextbox.Enabled = false;
                YInitialStepTextbox.Enabled = false;
                YCellNumberTextbox.Enabled = true;
            }
        }

        private void XAddButton_Click(object sender, EventArgs e)
        {
            double XStartingLocationDouble, XEndingLocationDouble, XStepRatioDouble, XInitialStepDouble;
            XStartingLocationDouble = XEndingLocationDouble = XStepRatioDouble = XInitialStepDouble = 0;
            int XCellNUmberInt = 0;
            try
            {
                XStartingLocationDouble = Convert.ToDouble(XStartingLocationTextbox.Text);
                XEndingLocationDouble = Convert.ToDouble(XEndingLocationTextbox.Text);
                if (XSteppingMethodCombo.SelectedIndex == 0)
                {
                    XStepRatioDouble = Convert.ToDouble(XStepRatioTextbox.Text);
                    XInitialStepDouble = Convert.ToDouble(XInitialStepTextbox.Text);
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
                {
                    double Temporary = (XStartingLocationDouble + counter * 1.0 * (XEndingLocationDouble - XStartingLocationDouble) / XCellNUmberInt);
                    XDataTemporary.Add(Math.Round(Temporary, 1));
                }
            }
            if (XSteppingMethodCombo.SelectedIndex == 0)
            {
                double counter = 0;
                XDataTemporary.Add(XStartingLocationDouble);
                while (true)
                {
                    double Temp = XStartingLocationDouble + XInitialStepDouble * Math.Pow(XStepRatioDouble, counter);
                    if (Temp <= XEndingLocationDouble)
                        XDataTemporary.Add(Math.Round(Temp, 1));
                    else
                    {
                        XDataTemporary.Add(XEndingLocationDouble);
                        break;
                    }
                    counter++;
                }
            }
            XMeshControl = true;
        }

        private void YAddButton_Click(object sender, EventArgs e)
        {
            double YStartingLocationDouble, YEndingLocationDouble, YStepRatioDouble, YInitialStepDouble;
            YStartingLocationDouble = YEndingLocationDouble = YStepRatioDouble = YInitialStepDouble = 0;
            int YCellNUmberInt = 0;
            try
            {
                YStartingLocationDouble = Convert.ToDouble(YStartingLocationTextbox.Text);
                YEndingLocationDouble = Convert.ToDouble(YEndingLocationTextbox.Text);
                if (YSteppingMethodCombo.SelectedIndex == 0)
                {
                    YStepRatioDouble = Convert.ToDouble(YStepRatioTextbox.Text);
                    YInitialStepDouble = Convert.ToDouble(YInitialStepTextbox.Text);
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
                {
                    double Temporary = YStartingLocationDouble + counter * 1.0 * (YEndingLocationDouble - YStartingLocationDouble) / YCellNUmberInt;
                    YDataTemporary.Add(Math.Round(Temporary, 1));
                }
            }
            if (YSteppingMethodCombo.SelectedIndex == 0)
            {
                double counter = 0;
                YDataTemporary.Add(YStartingLocationDouble);
                while (true)
                {
                    double Temp = YStartingLocationDouble + YInitialStepDouble * Math.Pow(YStepRatioDouble, counter);
                    if (Temp <= YEndingLocationDouble)
                        YDataTemporary.Add(Math.Round(Temp, 1));
                    else
                    {
                        YDataTemporary.Add(YEndingLocationDouble);
                        break;
                    }
                    counter++;
                }
            }
            YMeshControl = true;
        }

        private void CreateButton_Click(object sender, EventArgs e)
        {
            if (YMeshControl && XMeshControl)
            {
                XDataFinal.AddRange(XDataTemporary.Distinct().ToList());
                YDataFinal.AddRange(YDataTemporary.Distinct().ToList());
                MakingGrid();
            }
            else
            {
                MessageBox.Show("X Grid or Y Grid has not been successfully made, please rerun the program and makes sure you press add for each direction", "Griding Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            if (BottomBoundaryCombo.SelectedIndex != -1 && TopBoundaryCombo.SelectedIndex != -1 && RightBoundaryCombo.SelectedIndex != -1 && LeftBoundaryCombo.SelectedIndex != -1)
                BoundaryControl = true;
            else
            {
                MessageBox.Show("Boundary conditions have not been successfully made, please rerun the program and makes sure you press add for each direction", "Boundary Condition Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            WritingFunction();
        }
        private void MakingGrid()
        {
            //First two columns are rectangle centers, the very next 4 ones are node indices of each rectangle and the last 4 ones are each cell neighbours and the last one is the depth of Voronoi point.
            //Node indices have been numbered respectively: Left Top, Right Top, Right Bottom, Left Bottom
            //Neighbors have been numbered respectively: Bottom, Right, top, Left and -1 shows no neighbour
            cells = new double[(XDataFinal.Count - 1) * (YDataFinal.Count - 1), 11];
            for (int counter1 = 0; counter1 < YDataFinal.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XDataFinal.Count - 1; counter2++)
                {
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 0] = (XDataFinal[counter2] + XDataFinal[counter2 + 1]) / 2;
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 1] = (YDataFinal[counter1] + YDataFinal[counter1 + 1]) / 2;
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 2] = XDataFinal.Count * (counter1 + 1) + counter2;
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 3] = XDataFinal.Count * (counter1 + 1) + counter2 + 1;
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 4] = XDataFinal.Count * counter1 + counter2 + 1;
                    cells[counter2 + counter1 * (XDataFinal.Count - 1), 5] = XDataFinal.Count * counter1 + counter2;
                    if (counter1 != 0)
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 6] = (XDataFinal.Count - 1) * (counter1 - 1) + (counter2 + 0);
                    else
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 6] = -1;
                    if (counter2 != XDataFinal.Count - 2)
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 7] = (XDataFinal.Count - 1) * (counter1 + 0) + (counter2 + 1);
                    else
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 7] = -1;
                    if (counter1 != YDataFinal.Count - 2)
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 8] = (XDataFinal.Count - 1) * (counter1 + 1) + (counter2 + 0);
                    else
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 8] = -1;
                    if (counter2 != 0)
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 9] = (XDataFinal.Count - 1) * (counter1 + 0) + (counter2 - 1);
                    else
                        cells[counter2 + counter1 * (XDataFinal.Count - 1), 9] = -1;
                }
            }
            //The first column is the number of element face, the 2nd and 3rd columns are start and end of each edge, the 4th column is the boundary condition and the last two ones are Voronoi on either side of the edge. -1 means there is no point
            //For VerticalEdges: Down, Up,-, Right, Left
            //For HorizontalEdges: Right, Left, -, Down, Up
            VerticalEdges = new double[XDataFinal.Count * (YDataFinal.Count - 1), 5];
            for (int counter1 = 0; counter1 < YDataFinal.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XDataFinal.Count; counter2++)
                {
                    VerticalEdges[counter2 + counter1 * XDataFinal.Count, 0] = counter2 + (counter1 + 0) * XDataFinal.Count;
                    VerticalEdges[counter2 + counter1 * XDataFinal.Count, 1] = counter2 + (counter1 + 1) * XDataFinal.Count;
                    if (counter2 == 0)
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2] = Convert.ToInt16(LeftBoundaryCombo.SelectedIndex);
                    else if (counter2 == XDataFinal.Count - 1)
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2] = Convert.ToInt16(RightBoundaryCombo.SelectedIndex);
                    else
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2] = 0;
                    if (counter2 != XDataFinal.Count - 1)
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 3] = counter2 + counter1 * (XDataFinal.Count - 1);
                    else
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 3] = -1;
                    if (counter2 != 0)
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 4] = counter2 + counter1 * (XDataFinal.Count - 1) - 1;
                    else
                        VerticalEdges[counter2 + counter1 * XDataFinal.Count, 4] = -1;
                }
            }
            HorizontalEdges = new double[(XDataFinal.Count - 1) * YDataFinal.Count, 5];
            for (int counter1 = 0; counter1 < YDataFinal.Count; counter1++)
            {
                for (int counter2 = 0; counter2 < XDataFinal.Count - 1; counter2++)
                {
                    HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 0] = (counter2 + 1) + counter1 * XDataFinal.Count;
                    HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 1] = (counter2 + 0) + counter1 * XDataFinal.Count;
                    if (counter1 == 0)
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 2] = Convert.ToInt16(BottomBoundaryCombo.SelectedIndex);
                    else if (counter1 == YDataFinal.Count - 1)
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 2] = Convert.ToInt16(TopBoundaryCombo.SelectedIndex);
                    else
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 2] = 0;
                    if (counter1 != 0)
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 3] = counter2 + (counter1 - 1) * (XDataFinal.Count - 1);
                    else
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 3] = -1;
                    if (counter1 != YDataFinal.Count - 1)
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 4] = counter2 + (counter1 - 0) * (XDataFinal.Count - 1);
                    else
                        HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 4] = -1;
                }
            }
            GridControl = true;
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
            try
            {
                PointWriter = new StreamWriter(ResultAdressTextbox.Text + "points.dat");
                CellWriter = new StreamWriter(ResultAdressTextbox.Text + "cells.dat");
                EdgeWriter = new StreamWriter(ResultAdressTextbox.Text + "edges.dat");
            }
            catch (Exception Exp1)
            {
                MessageBox.Show(string.Format("{0}/r/n{1}", "There is an error in writing the result file", Exp1.Message.ToString()), "Writing Reult File", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw;
            }
            //Writing points.dat
            //The 1st, 2nd and 3rd columns are X, Y, Point number
            int counter = 0;
            foreach (double YDirection in YDataFinal)
            {
                foreach (double XDirection in XDataFinal)
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
            for (int counter1 = 0; counter1 < (XDataFinal.Count - 1) * (YDataFinal.Count - 1); counter1++)
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
            for (int counter1 = 0; counter1 < YDataFinal.Count - 1; counter1++)
            {
                for (int counter2 = 0; counter2 < XDataFinal.Count; counter2++)
                {
                    //Please be advised about the reverse order of 3rd and 4th columns
                    //string Temporary = string.Format("{0}\t{1}\t{2}\t{4}\t{3}", VerticalEdges[counter2 + counter1 * XDataFinal.Count, 0], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 1], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 3], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 4]);
                    string Temporary = string.Format("{0}\t{1}\t{2}\t{4}\t{3}", VerticalEdges[counter2 + counter1 * XDataFinal.Count, 0], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 1], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 3], VerticalEdges[counter2 + counter1 * XDataFinal.Count, 4]);
                    EdgeWriter.Write(Temporary);
                    EdgeWriter.Write("\n");
                    
                    /*
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XDataFinal.Count, 0]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XDataFinal.Count, 1]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XDataFinal.Count, 2]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.Write(VerticalEdges[counter2 + counter1 * XDataFinal.Count, 3]);
                    EdgeWriter.Write("   ");
                    EdgeWriter.WriteLine(VerticalEdges[counter2 + counter1 * XDataFinal.Count, 4]);
                     */
                }
            }
            for (int counter1 = 0; counter1 < YDataFinal.Count; counter1++)
            {
                for (int counter2 = 0; counter2 < XDataFinal.Count - 1; counter2++)
                {
                    //Please be advised about the reverse order of 3rd and 4th columns
                    string Temporary = string.Format("{0}\t{1}\t{2}\t{3}\t{4}", HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 0], HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 1], HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 2], HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 3], HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 4]);
                    EdgeWriter.Write(Temporary);
                    EdgeWriter.Write("\n");
                    /*
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 0]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 1]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 2]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.Write(HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 3]);
                    EdgeWriter.Write("    ");
                    EdgeWriter.WriteLine(HorizontalEdges[counter2 + counter1 * (XDataFinal.Count - 1), 4]);
                     */
                }
            }
            EdgeWriter.Close();
            MessageBox.Show("The grid have been made successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }
    }
}

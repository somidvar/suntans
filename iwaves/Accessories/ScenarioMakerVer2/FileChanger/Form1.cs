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

//This program has been written at University of Georgia by Sorush Omidvar under the supervision of Dr. Woodson in Jun 2016 to modify a batch file of Suntans runs.
namespace FileChanger
{
    public partial class Form1 : Form
    {
        string MotherDirectory;
        const bool CaseChecker = false;
        const int CaseNumber = 481;
        public Form1()
        {
            InitializeComponent();
            MotherDirectory = @"D:\Newfolder\suntans-triangular-";
            SourceDirectoryTB.Text = MotherDirectory;
        }
        public void ArgumentInitializer()
        {

            StreamReader CSVParamaters = new StreamReader("D:\\Parameters.csv");
            string CSVContent = CSVParamaters.ReadLine();
            double[] PycnoclineDepth, M2Amplitude, K1Amplitude, K1Phase, WindSpeed, WindPhase;
            PycnoclineDepth = new double[CaseNumber];
            M2Amplitude = new double[CaseNumber];
            K1Amplitude = new double[CaseNumber];
            K1Phase = new double[CaseNumber];
            WindSpeed = new double[CaseNumber];
            WindPhase = new double[CaseNumber];
            
            int CaseCounter = 0;
            string[] CSVContentDelim;
            while (!CSVParamaters.EndOfStream)
            {
                try
                {
                    CSVContent = CSVParamaters.ReadLine();
                    CSVContentDelim = CSVContent.Split(',');
                    PycnoclineDepth[CaseCounter] = Convert.ToDouble(CSVContentDelim[2]);
                    M2Amplitude[CaseCounter] = Convert.ToDouble(CSVContentDelim[4]);
                    K1Amplitude[CaseCounter] = Convert.ToDouble(CSVContentDelim[8]);
                    K1Phase[CaseCounter] = Convert.ToDouble(CSVContentDelim[10]);
                    WindSpeed[CaseCounter] = Convert.ToDouble(CSVContentDelim[12]);
                    WindPhase[CaseCounter] = Convert.ToDouble(CSVContentDelim[14]);
                    CaseCounter++;
                }
                catch (Exception Exp1)
                {
                    MessageBox.Show(string.Format("The operation was unsuccessfull. {0}", Exp1.Message), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

            }
            if (CaseCounter != CaseNumber)
            {
                MessageBox.Show("Error in Case reading.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            string[] Address = new string[CaseNumber];
            string[] ExtensionNumber = new string[CaseNumber];
            int FileCounter = 0;
            //Creating file address array
            if (!CaseChecker)
            {
                for (FileCounter = 0; FileCounter < CaseNumber; FileCounter++)
                {
                    Address[FileCounter] = string.Concat(MotherDirectory, Convert.ToString(FileCounter + 110000));
                    DirectoryMaker(MotherDirectory, Address[FileCounter]);
                    SUNTANSDATModifier(Address[FileCounter], PycnoclineDepth[FileCounter], M2Amplitude[FileCounter], K1Amplitude[FileCounter], K1Phase[FileCounter], WindPhase[FileCounter], WindSpeed[FileCounter]);
                    IWavesModifier(Address[FileCounter]);
                }
                MessageBox.Show("The creation was successfull.", "Done", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
            }
            //Reading suntans.dat for each case
            FileCounter = 0;
            if (CaseChecker)
            {
                for (FileCounter = 0; FileCounter < CaseNumber; FileCounter++)
                {
                    Address[FileCounter] = string.Concat(MotherDirectory, Convert.ToString(FileCounter + 110000));
                    SUNTANSChecker(Address[FileCounter], PycnoclineDepth[FileCounter], M2Amplitude[FileCounter], K1Amplitude[FileCounter], K1Phase[FileCounter], WindPhase[FileCounter], WindSpeed[FileCounter]);
                }
                MessageBox.Show("The check was successfull.", "Done", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
            }
        }
        public void SUNTANSDATModifier(string Address, double PycnoclineDepth, double M2Amplitude, double K1Amplitude, double K1Phase, double WindPhase, double WindSpeed)
        {
            Address += "\\iwaves\\rundata\\suntans.dat";
            string Context = string.Empty;
            int LineCounter = 0;
            int M2AmplitudeLine = 62;
            int K1AmplitudeLine = 63;
            int K1PhaseLine = 64;
            int WindPhaseLine = 65;
            int PycnoclineDepthLine = 66;
            int WindStressLine = 67;
            StreamReader Reader;
            Reader = new StreamReader(Address);
            while (!Reader.EndOfStream)
            {
                if (LineCounter == M2AmplitudeLine)
                {
                    Context += string.Format("M2TideAmplitude\t\t{0}# Semi-Diurnal Tidal amplitude at sea-side for U Barotropic 0.006 is 0.1454", M2Amplitude);
                    Reader.ReadLine();
                }
                else if (LineCounter == K1AmplitudeLine)
                {
                    Context += string.Format("K1TideAmplitude\t\t{0}# Diurnal Tidal amplitude at sea-side for U Barotropic 0.004 is 0.1027", K1Amplitude);
                    Reader.ReadLine();
                }
                else if (LineCounter == K1PhaseLine)
                {
                    Context += string.Format("TidePhaseDifference\t\t{0}# Initial phase of K1 tide by ----Sorush Omidvar----", K1Phase);
                    Reader.ReadLine();
                }
                else if (LineCounter == WindPhaseLine)
                {
                    Context += string.Format("WindPhaseDifference\t{0}# The lag time between wind and tide in sec used by Omidvar and Woodson", WindPhase);
                    Reader.ReadLine();
                }
                else if (LineCounter == PycnoclineDepthLine)
                {
                    Context += string.Format("PycnoclineDepth\t\t{0}# Depth of the halocline Used by Omidvar and Woodson salinity=ASal*tanh(BSal*(-Z-CSal)+DSal", PycnoclineDepth);
                    Reader.ReadLine();
                }
                else if (LineCounter == WindStressLine)
                {
                    Context += string.Format("tau_T\t\t\t\t{0}# Wind shear stress", 1.2*1.22*WindSpeed* WindSpeed/1000/1000);
                    Reader.ReadLine();
                }
                else
                    Context += Reader.ReadLine();
                Context += "\r\n";
                LineCounter++;
            }
            Reader.Close();
            if(File.Exists(Address))
                File.Delete(Address);
            StreamWriter Writer = new StreamWriter(Address);
            Writer.Write(Context);
            Writer.Close();
        }
        public void SUNTANSChecker(string Address, double PycnoclineDepth, double M2Amplitude, double K1Amplitude, double K1Phase,double WindPhase,double WindSpeed)
        {
            Address += "\\iwaves\\rundata\\suntans.dat";
            string VariableCheckTempstr= string.Empty;
            int LineCounter = 0;
            int M2AmplitudeLine = 62;
            int K1AmplitudeLine = 63;
            int K1PhaseLine = 64;
            int WindPhaseLine = 65;
            int PycnoclineDepthLine = 66;
            int WindStressLine = 67;
            char[] SplitChars = { ' ', '\t','#'};
            StreamReader Reader;
            Reader = new StreamReader(Address);
            while (!Reader.EndOfStream)
            {
                if (LineCounter == M2AmplitudeLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != M2Amplitude)
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else if (LineCounter == K1AmplitudeLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != K1Amplitude)
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else if (LineCounter == K1PhaseLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != K1Phase)
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else if (LineCounter == WindPhaseLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != WindPhase)
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else if (LineCounter == PycnoclineDepthLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != PycnoclineDepth)
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else if (LineCounter == WindStressLine)
                {
                    VariableCheckTempstr = Reader.ReadLine();
                    string[] VariableCheckTempstrArr = VariableCheckTempstr.Split(SplitChars, StringSplitOptions.RemoveEmptyEntries);
                    if (Convert.ToDouble(VariableCheckTempstrArr[1]) != Math.Round(1.2*1.22*WindSpeed*WindSpeed/1000/1000,10))
                    {
                        MessageBox.Show(string.Format("The check has failed in . {0}", Address), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                else
                    Reader.ReadLine();
                LineCounter++;
            }
            Reader.Close();
        }
        public void IWavesModifier(string Address)
        {
            string CaseNumber = Address.Substring(Address.LastIndexOf('-') + 1, 6);
            Address += "\\iwaves\\iwaves_sub.sh";
            try
            {
                StreamReader IWavesReader = new StreamReader(Address);
                string IWaves = string.Empty;
                int IWavesCounter = 0;
                while (!IWavesReader.EndOfStream)
                {
                    if (IWavesCounter == 2)
                    {
                        IWaves += @"#PBS -N ";
                        IWaves += "IW-";
                        IWaves += CaseNumber;
                        IWaves += "\n";
                        IWavesReader.ReadLine();
                    }
                    else
                    {
                        IWaves += IWavesReader.ReadLine();
                        IWaves += "\n";
                    }
                    IWavesCounter++;
                }
                IWavesReader.Close();
                if (File.Exists(Address))
                    File.Delete(Address);
                StreamWriter IWavesWriter = new StreamWriter(Address);
                IWavesWriter.Write(IWaves);
                IWavesWriter.Close();
            }
            catch (Exception Exp2)
            {
                MessageBox.Show(string.Format("The operation was unsuccessfull. {0}", Exp2.Message), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }
        public void DirectoryMaker(string SourceDirectory, string DestinationDirectory)
        {
            if (Directory.Exists(DestinationDirectory))
                Directory.Delete(DestinationDirectory, true);
            try
            {
                DirectoryInfo Directory = new DirectoryInfo(SourceDirectory);
                DirectoryInfo[] SubDirectories = Directory.GetDirectories();
                // If the destination directory doesn't exist, create it.
                if (!System.IO.Directory.Exists(DestinationDirectory))
                {
                    System.IO.Directory.CreateDirectory(DestinationDirectory);
                }
                // Get the files in the directory and copy them to the new location.
                FileInfo[] files = Directory.GetFiles();
                foreach (FileInfo file in files)
                {
                    string TemporaryPath = Path.Combine(DestinationDirectory, file.Name);
                    file.CopyTo(TemporaryPath, false);
                }
                // Copying subdirectories, copy them and their contents to new location.
                foreach (DirectoryInfo subdir in SubDirectories)
                {
                    string TempPath = Path.Combine(DestinationDirectory, subdir.Name);
                    DirectoryMaker(subdir.FullName, TempPath);
                }

            }
            catch (Exception Exp3)
            {
                MessageBox.Show(string.Format("The operation was unsuccessfull. {0}", Exp3.Message), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
        }
        private void SourceDirectoryBT_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog SourceFolderBrowserDialog = new FolderBrowserDialog();
            SourceFolderBrowserDialog.ShowDialog();
            MotherDirectory = SourceFolderBrowserDialog.SelectedPath;
            SourceDirectoryTB.Text = MotherDirectory;
        }
        private void CreateBT_Click(object sender, EventArgs e)
        {
            ArgumentInitializer();
        }
    }
}
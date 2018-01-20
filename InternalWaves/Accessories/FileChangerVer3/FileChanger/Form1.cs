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
        const int TauCases = 5;
        const int PycnoclineCases = 5;
        const int WaveAmplitudeCases = 4;
        const int FrontWindCases = 1;
        int FileNumber;
        string MotherDirectory;
        public Form1()
        {
            FileNumber = TauCases * PycnoclineCases * WaveAmplitudeCases* FrontWindCases;
            InitializeComponent();
            MotherDirectory = @"D:\suntans-6th";
            SourceDirectoryTB.Text = MotherDirectory;
        }
        public void ArgumentInitializer()
        {
            string[] Address = new string[FileNumber];
            string[] ExtensionNumber = new string[FileNumber];
            double Tau_T=-1000;
            double NSteps=6e5;
            double DiurnalAmplitude=-1000;
            double SemiDiurnalAmplitude=-1000;
            double Pycnocline=-1000;
            double FrontWind = -1000;
            int FileCounter=0;
            //Creating file address array
            for (FileCounter = 0; FileCounter < FileNumber; FileCounter++)
            {
                Address[FileCounter] = MotherDirectory;
                ExtensionNumber[FileCounter] = string.Empty;
                ExtensionNumber[FileCounter] = "-"+ (FileCounter + 10000).ToString();
                Address[FileCounter] += ExtensionNumber[FileCounter];
                DirectoryMaker(MotherDirectory,Address[FileCounter]);
            }
            //Reading suntans.dat for each case
            FileCounter = 0;
            for (int TauCounter = 0; TauCounter < TauCases; TauCounter++)
            {
                Tau_T = 0;
                switch (TauCounter % TauCases)
                {
                    case 0:
                        Tau_T = 0;
                        break;
                    case 1:
                        Tau_T = 2e-5;
                        break;
                    case 2:
                        Tau_T = 4e-5;
                        break;
                    case 3:
                        Tau_T = 6e-5;
                        break;
                    case 4:
                        Tau_T = 8e-5;
                        break;
                    default:
                        break;
                }
                for (int PycnoclineCounter = 0; PycnoclineCounter < PycnoclineCases; PycnoclineCounter++)
                {
                    switch (PycnoclineCounter % PycnoclineCases)
                    {
                        case 0:
                            Pycnocline = 5;
                            //BruntVaisalaMax = 0.0212;// This is the value for 21 meters Pycnocline. 
                            //BruntVaisalaMax = 0.0246;
                            break;
                        case 1:
                            Pycnocline = 10;
                            //BruntVaisalaMax = 0.0212;// This is the value for 21 meters Pycnocline. 
                            //BruntVaisalaMax = 0.0235;
                            break;
                        case 2:
                            Pycnocline = 15;
                            //BruntVaisalaMax = 0.0212;// This is the value for 21 meters Pycnocline. 
                            //BruntVaisalaMax = 0.0227;
                            break;
                        case 3:
                            Pycnocline = 20;
                            //BruntVaisalaMax = 0.0212;// This is the value for 21 meters Pycnocline. 
                            //BruntVaisalaMax = 0.0222;
                            break;
                        case 4:
                            Pycnocline = 25;
                            //BruntVaisalaMax = 0.0212;// This is the value for 21 meters Pycnocline. 
                            //BruntVaisalaMax = 0.0218;
                            break;
                        default:
                            break;
                    }
                    for (int WaveAmplitudeCounter = 0; WaveAmplitudeCounter < WaveAmplitudeCases; WaveAmplitudeCounter++)
                    {
                        DiurnalAmplitude = 0;
                        SemiDiurnalAmplitude = 0;
                        switch (WaveAmplitudeCounter % WaveAmplitudeCases)
                        {
                            case 0:
                                DiurnalAmplitude = 0;
                                SemiDiurnalAmplitude = 0;
                                break;
                            case 1:
                                DiurnalAmplitude = -2.95e-2;
                                SemiDiurnalAmplitude = 0;
                                break;
                            case 2:
                                DiurnalAmplitude = 0;
                                SemiDiurnalAmplitude = -7.5e-2;
                                break;
                            case 3:
                                DiurnalAmplitude = -2.95e-2;
                                SemiDiurnalAmplitude = -7.5e-2;
                                break;
                            default:
                                break;
                        }
                        for (int FrontWindCounter = 0; FrontWindCounter < FrontWindCases; FrontWindCounter++)
                        {
                            FrontWind = 0;
                            /*
                            switch (FrontWindCounter % FrontWindCases)
                            {
                                case 0:
                                    FrontWind = 1.5e-5;
                                    break;
                                case 1:
                                    FrontWind = 3e-5;
                                    break;
                                case 2:
                                    FrontWind = 4.5e-5;
                                    break;
                                default:
                                    break;
                            }
                            */
                            try
                            {
                                SUNTANSDATModifier(Address[FileCounter], Tau_T, NSteps, DiurnalAmplitude, SemiDiurnalAmplitude, Pycnocline,FrontWind);
                                IWavesModifier(Address[FileCounter]);
                            }
                            catch (Exception Exp1)
                            {
                                MessageBox.Show(string.Format("The operation was unsuccessfull. {0}", Exp1.Message), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                return;
                            }
                            FileCounter++;
                        }
                    }
                }
            }
            MessageBox.Show("The operation was successfull.", "Done", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }
        public void SUNTANSDATModifier(string Address, double Tau_T, double NSteps, double DiurnalAmplitude, double SemiDiurnalAmplitude, double Pycnocline, double FrontWind)
        {
            Address += "\\InternalWaves\\rundata\\suntans.dat";
            string Context = string.Empty;
            int LineCounter = 0;
            int TauTLine = 67;
            int OutputLine = 36;
            int DiurnalLine = 104;
            int SemiDiurnalLine = 106;
            int PycnoclineLine = 110;
            int FrontWindLine = 119;
            StreamReader Reader;
            Reader = new StreamReader(Address);
            while (!Reader.EndOfStream)
            {
                if (LineCounter == TauTLine)
                {
                    Context += string.Format("tau_T\t\t\t\t\t\t\t{0}\t\t\t# Wind shear stress",Tau_T);
                    Reader.ReadLine();
                }
                else if (LineCounter == OutputLine)
                {
                    Context += string.Format("nsteps\t\t\t\t\t\t\t{0}\t\t\t# Number of steps",NSteps);
                    Reader.ReadLine();
                }
                else if (LineCounter == DiurnalLine)
                {
                    Context += string.Format("DiurnalTideAmplitude\t\t\t{0}\t\t\t# Diurnal Tidal amplitude at sea-side for 72 cm wave at shore-side -2.95e-2",DiurnalAmplitude);
                    Reader.ReadLine();
                }
                else if (LineCounter == SemiDiurnalLine)
                {
                    Context += string.Format("SemiDiurnalTideAmplitude\t\t{0}\t\t\t# Semi-Diurnal Tidal amplitude at sea-side for 98 cm wave at shore-side -7.5e-2",SemiDiurnalAmplitude);
                    Reader.ReadLine();
                }
                else if (LineCounter == PycnoclineLine)
                {
                    Context += string.Format("CSal\t\t\t\t\t\t\t{0}\t\t\t# Depth of the halocline Used by Omidvar and Woodson salinity=ASal*tanh(BSal*(-Z-CSal)+DSal or Salinity=ASal*pow(-Z or CSal,BSal)+DSal", Pycnocline);
                    Reader.ReadLine();
                }
                else if (LineCounter==FrontWindLine)
                {
                    Context += string.Format("FrontWindStress\t\t\t\t\t\t{0}\t\t\t# Adding wind on the front to make it more stable. This is Tau value and formulated similar to tau_T= Tau/Rho", FrontWind);
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
        public void IWavesModifier(string Address)
        {
            string CaseNumber = Address.Substring(Address.LastIndexOf('-') + 1, 5);
            Address += "\\InternalWaves\\iwaves_sub.sh";
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
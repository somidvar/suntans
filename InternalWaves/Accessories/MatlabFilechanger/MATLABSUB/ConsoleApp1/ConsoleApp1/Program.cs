using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace ConsoleApp1
{
    class Program
    {
        static int TidalScenario, WindScenario, PycnoclineScenario,LagScenario,VersionSeries;
        static void Main(string[] args)
        {
            TidalScenario = 4;
            WindScenario = 7;
            PycnoclineScenario = 7;
            LagScenario = 8;
            VersionSeries = 90000;
                
            MATLABSubWriter();
            MATLABMainSingleWriter();
            MATLABEnergyFluxWriter();
        }
        static void MATLABSubWriter()
        {
            for (int counter = 0; counter < TidalScenario*WindScenario*PycnoclineScenario*LagScenario; counter++)
            {
                string MatlabSub = string.Empty;
                MatlabSub += "#PBS -S /bin/bash\n";
                MatlabSub += "#PBS -q batch\n";
                MatlabSub += string.Format("#PBS -N MATLABJOB{0}", counter + VersionSeries)+"\n";
                MatlabSub += "#PBS -l nodes=1:ppn=12:AMD\n";
                MatlabSub += "#PBS -l walltime=2:00:00\n";
                MatlabSub += "#PBS -l mem=60gb\n";
                MatlabSub += "# PBS -M omidvar@uga.edu\n";
                MatlabSub += "#PBS -m e\n"+"\n\n";
                MatlabSub += "cd $PBS_O_WORKDIR\n";
                MatlabSub += @"ml matlab/R2017b"+"\n\n";
                MatlabSub += @"matlab -nodisplay </lustre1/omidvar/work-directory_0801/MatlabFiles/MainSingle"+(counter+VersionSeries).ToString()+ @".m> matlab_${PBS_JOBID}.out";
                string OutputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MATLABSub{0}.sh", counter+VersionSeries);
                StreamWriter MATLABSUBWriter = new StreamWriter(OutputAddress);
                MATLABSUBWriter.Write(MatlabSub);
                MATLABSUBWriter.Close();
            }
        }
        static void MATLABMainSingleWriter()
        {
            StreamReader MainSingleStreamReader = new StreamReader("D:\\github\\suntans\\InternalWaves\\matlabcode\\MainSingle.m");
            for (int counterSkipper = 0; counterSkipper < 8; counterSkipper++)
                MainSingleStreamReader.ReadLine();
            string MainSingleBody = MainSingleStreamReader.ReadToEnd();
            MainSingleStreamReader.Close();

            for (int counter = 0; counter < TidalScenario*WindScenario*PycnoclineScenario*LagScenario; counter++)
            {
                double DiurnalTideOmega, SemiDiurnalTideOmega, WindTauMax,WindOmega;
                DiurnalTideOmega = SemiDiurnalTideOmega = WindTauMax =WindOmega= -9999;
                WindOmega= 2 * Math.PI / (24 * 3600);
                DiurnalTideOmega = 2 * Math.PI / (23.93 * 3600);
                SemiDiurnalTideOmega = 2 * Math.PI / (12.42 * 3600);
                switch (counter % TidalScenario)
                {
                    case 0:
                        DiurnalTideOmega = 0;
                        SemiDiurnalTideOmega = 0;
                        break;
                    case 1:
                        DiurnalTideOmega = 2 * Math.PI / (23.93 * 3600);
                        SemiDiurnalTideOmega = 0;
                        break;
                    case 2:
                        DiurnalTideOmega = 0;
                        SemiDiurnalTideOmega = 2 * Math.PI / (12.42 * 3600);
                        break;
                    case 3:
                        DiurnalTideOmega = 2 * Math.PI / (23.93 * 3600);
                        SemiDiurnalTideOmega = 2 * Math.PI / (12.42 * 3600);
                        break;
                }
                switch (Convert.ToInt32((counter% (PycnoclineScenario * TidalScenario*WindScenario)) /(PycnoclineScenario * TidalScenario)))
                {
                    case 0:
                        WindTauMax = 0;
                        break;
                    case 1:
                        WindTauMax = 0.14e-5;
                        break;
                    case 2:
                        WindTauMax = 0.57e-5;
                        break;
                    case 3:
                        WindTauMax = 1.29e-5;
                        break;
                    case 4:
                        WindTauMax = 2.29e-5;
                        break;
                    case 5:
                        WindTauMax = 3.57e-5;
                        break;
                    case 6:
                        WindTauMax = 5.14e-5;
                        break;
                }
                string MainSingleString = "close all;\r\nclear all;\r\nclc\r\n\r\n";
                MainSingleString += string.Format("CaseNumber={0};\r\n", counter + VersionSeries);
                MainSingleString += string.Format("DiurnalTideOmega={0};\r\n", DiurnalTideOmega.ToString("e4"));
                MainSingleString += string.Format("SemiDiurnalTideOmega={0};\r\n", SemiDiurnalTideOmega.ToString("e4"));
                MainSingleString += string.Format("WindOmega={0};\r\n", WindOmega.ToString("e4"));
                MainSingleString += string.Format("WindTauMax={0};\r\n", WindTauMax);
                MainSingleString += MainSingleBody;
                for (int EndLineCounter = 0; EndLineCounter < 10; EndLineCounter++)
                    MainSingleString = MainSingleString.Remove(MainSingleString.LastIndexOf('\n'));

                MainSingleString += string.Format("EnergyFluxCalculator{0}", counter + VersionSeries);
                MainSingleString += "(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,SapeloFlag);\r\n";
                string outputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MainSingle{0}.m", counter + VersionSeries);
                StreamWriter MainSingleStreamWriter = new StreamWriter(outputAddress);
                MainSingleStreamWriter.Write(MainSingleString);
                MainSingleStreamWriter.Close();
            }
        }
        static void MATLABEnergyFluxWriter()
        {
            StreamReader EnergyFluxCalculatorStreamReader = new StreamReader("D:\\github\\suntans\\InternalWaves\\matlabcode\\EnergyFluxCalculator.m");
            for (int counterSkipper = 0; counterSkipper < 17; counterSkipper++)
                EnergyFluxCalculatorStreamReader.ReadLine();
            string EnergyFluxBody = EnergyFluxCalculatorStreamReader.ReadToEnd();
            EnergyFluxCalculatorStreamReader.Close();
            for (int counter = 0; counter < TidalScenario*WindScenario*PycnoclineScenario*LagScenario; counter++)
            {
                string EnergyFluxString = string.Format("function EnergyFluxCalculator{0}", counter + VersionSeries);
                EnergyFluxString += "(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,SapeloFlag)\r\n";
                EnergyFluxString += EnergyFluxBody;
                string outputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\EnergyFluxCalculator{0}.m", counter + VersionSeries);
                StreamWriter EnergyFluxCalculatorWriter = new StreamWriter(outputAddress);
                EnergyFluxCalculatorWriter.Write(EnergyFluxString);
                EnergyFluxCalculatorWriter.Close();
            }
        }
    }
}

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
        static void Main(string[] args)
        {
            FileReaderFun();
        }
        static void FileReaderFun()
        {
            string AddressMother = @"\\Engr668595d\WD1\9th\9th\suntans-9th-";
            int Series = 90000;
            //string LogTotal = string.Empty;
            List<double> Cz=new List<double>();
            List<double> Cx = new List<double>();
            for (int CaseCounter = 1; CaseCounter < 979; CaseCounter++)
            {
                string Address = AddressMother + (Series + CaseCounter).ToString()+"\\InternalWaves";
                if (!Directory.Exists(Address))
                    continue;
                string[] LogFile = System.IO.Directory.GetFiles(Address, "*.pbs.scm.out");
                StreamReader LogReader = new StreamReader(LogFile[0]);
                while (!LogReader.EndOfStream)
                {
                    string CurrentLine = LogReader.ReadLine();
                    if (CurrentLine.Length >= 4)
                    {
                        if (CurrentLine.Substring(0, 4).Contains('%'))
                        {
                            char[] separators = { ' ', '=',',' };
                            string[] Temporary = CurrentLine.Split(separators);
                            Cx.Add(Convert.ToDouble(Temporary[4]));
                            Cz.Add(Convert.ToDouble(Temporary[7]));
                            //LogTotal += CurrentLine + "\n";
                        }
                    }
                }
                LogReader.Close();
                //LogTotal += "-----Done-----\n";
                //LogTotal += (Series + CaseCounter + 1).ToString()+"\n";
            }
            //StreamWriter LogWriter = new StreamWriter("D:\\LogTotal.txt");
            //LogWriter.Write(LogTotal);
            //LogWriter.Close();
            Console.WriteLine(Cx.Max());
            Console.WriteLine(Cz.Max());
            Console.ReadKey();
        }
    }
}

namespace FileChanger
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.label1 = new System.Windows.Forms.Label();
            this.SourceDirectoryTB = new System.Windows.Forms.TextBox();
            this.SourceDirectoryBT = new System.Windows.Forms.Button();
            this.CreateBT = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Times New Roman", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(12, 18);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(190, 21);
            this.label1.TabIndex = 0;
            this.label1.Text = "Main SUNTANS Folder";
            // 
            // SourceDirectoryTB
            // 
            this.SourceDirectoryTB.Font = new System.Drawing.Font("Times New Roman", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SourceDirectoryTB.Location = new System.Drawing.Point(208, 15);
            this.SourceDirectoryTB.Name = "SourceDirectoryTB";
            this.SourceDirectoryTB.Size = new System.Drawing.Size(328, 27);
            this.SourceDirectoryTB.TabIndex = 2;
            // 
            // SourceDirectoryBT
            // 
            this.SourceDirectoryBT.Font = new System.Drawing.Font("Times New Roman", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SourceDirectoryBT.Location = new System.Drawing.Point(542, 14);
            this.SourceDirectoryBT.Name = "SourceDirectoryBT";
            this.SourceDirectoryBT.Size = new System.Drawing.Size(113, 30);
            this.SourceDirectoryBT.TabIndex = 6;
            this.SourceDirectoryBT.Text = "Address";
            this.SourceDirectoryBT.UseVisualStyleBackColor = true;
            this.SourceDirectoryBT.Click += new System.EventHandler(this.SourceDirectoryBT_Click);
            // 
            // CreateBT
            // 
            this.CreateBT.Font = new System.Drawing.Font("Times New Roman", 10.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CreateBT.Location = new System.Drawing.Point(542, 50);
            this.CreateBT.Name = "CreateBT";
            this.CreateBT.Size = new System.Drawing.Size(113, 30);
            this.CreateBT.TabIndex = 7;
            this.CreateBT.Text = "Create";
            this.CreateBT.UseVisualStyleBackColor = true;
            this.CreateBT.Click += new System.EventHandler(this.CreateBT_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(667, 92);
            this.Controls.Add(this.CreateBT);
            this.Controls.Add(this.SourceDirectoryBT);
            this.Controls.Add(this.SourceDirectoryTB);
            this.Controls.Add(this.label1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.Text = "SUNTANS Project Modifier";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox SourceDirectoryTB;
        private System.Windows.Forms.Button SourceDirectoryBT;
        private System.Windows.Forms.Button CreateBT;
    }
}


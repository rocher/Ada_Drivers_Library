------------------------------------------------------------------------------
--                                                                          --
--                        Copyright (C) 2017, AdaCore                       --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with STM32.Device;  use STM32.Device;
with Ada.Real_Time; use Ada.Real_Time;

package body STM32.Setup is

   ----------------------
   -- Setup_I2C_Master --
   ----------------------

   procedure Setup_I2C_Master (Port        : in out I2C_Port;
                               SDA_SCL     : GPIO_Points;
                               GPIO_AF     : GPIO_Alternate_Function;
                               Clock_Speed : UInt32)
   is
      I2C_Conf : I2C_Configuration;
   begin
      --  GPIO --
      Enable_Clock (SDA_SCL);

      Configure_Alternate_Function (SDA_SCL, GPIO_AF);

      Configure_IO (SDA_SCL,
                    (Speed       => Speed_High,
                     Mode        => Mode_AF,
                     Output_Type => Open_Drain,
                     Resistors   => Floating));
      Lock (SDA_SCL);

      -- I2C --

      Enable_Clock (Port);
      delay until Clock + Milliseconds (200);
      Reset (Port);

      I2C_Conf.Own_Address := 16#00#;
      I2C_Conf.Addressing_Mode := Addressing_Mode_7bit;
      I2C_Conf.General_Call_Enabled := False;
      I2C_Conf.Clock_Stretching_Enabled := True;

      I2C_Conf.Clock_Speed := Clock_Speed;

      Port.Configure (I2C_Conf);
   end Setup_I2C_Master;

end STM32.Setup;

with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams; use Ada.Streams;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

procedure File_Encrypt_Decrypt is
   Key : Character := 'A'; -- Simple single character key for XOR
   Source_File, Dest_File : File_Type;
   Buffer : Stream_Element_Array(1..1024);
   Last  : Stream_Element_Offset;

   procedure Process_File is
   begin
      while not End_Of_File(Source_File) loop
         Read (Source_File, Buffer, Last);
         -- XOR Encryption/Decryption
         for I in Buffer'Range loop
            if I <= Last then
               Buffer(I) := Stream_Element'Val(Stream_Element'Pos(Buffer(I)) xor Stream_Element'Pos(Key));
            end if;
         end loop;
         Write (Dest_File, Buffer(1..Last));
      end loop;
   end Process_File;

begin
   -- Command line arguments processing
   if Ada.Command_Line.Argument_Count /= 3 then
      Ada.Text_IO.Put_Line("Usage: file_encrypt_decrypt <source> <destination> <key>");
      return;
   end if;

   -- File operations
   begin
      Open (Source_File, In_File, Ada.Command_Line.Argument(1));
      Create (Dest_File, Out_File, Ada.Command_Line.Argument(2));
      Key := Ada.Command_Line.Argument(3)(1); -- First character of the third argument as key
      Process_File;
   exception
      when E : others =>
         Ada.Text_IO.Put_Line("An error occurred: " & Exception_Message(E));
   end;

   -- Close files
   Close(Source_File);
   Close(Dest_File);
end File_Encrypt_Decrypt;

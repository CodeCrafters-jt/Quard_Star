OUTPUT_ARCH( "riscv" )

ENTRY( _start )

__stack_size = 0x4000;

MEMORY
{ 
	/* Fake ROM area */
	rom (rxa) : ORIGIN = 0xBF800000, LENGTH = 1M
	ram (wxa) : ORIGIN = 0xBF900000, LENGTH = 6M
}
SECTIONS
{
  .init :
	{
		_text = .;
		KEEP (*(SORT_NONE(.init)))
	} >rom AT>rom

  .text :
	{
		*(.text.unlikely .text.unlikely.*)
		*(.text.startup .text.startup.*)
		*(.text .text.*)
		*(.gnu.linkonce.t.*)
	} >rom AT>rom

  .fini :
	{
		KEEP (*(SORT_NONE(.fini)))
		_etext = .;
	} >rom AT>rom
  /* 四字节对齐 */
	.rodata.align :
	{
		. = ALIGN(4);
		_rodata = .;
	} >rom AT>rom

  /*  标记 rodata的链接地址*/
	.rodata.start :
	{
		_rodata_lma = LOADADDR(.rodata.start);
	} >rom AT>rom

  .data.align :
	{
		. = ALIGN(4);
		_data = .;
	} >ram AT>rom

  .data.start :
	{
		_data_lma = LOADADDR(.data.start);
	} >ram AT>rom

  .data :
	{
		*(.data .data.*)
		*(.gnu.linkonce.d.*)
		. = ALIGN(8);
		PROVIDE( __global_pointer$ = . + 0x800 );
		*(.sdata .sdata.*)
		*(.sdata2 .sdata2.*)
		*(.gnu.linkonce.s.*)
		. = ALIGN(8);
		*(.srodata.cst16)
		*(.srodata.cst8)
		*(.srodata.cst4)
		*(.srodata.cst2)
		*(.srodata .srodata.*)

		. = ALIGN(4);
		_edata = .;
	} >ram AT>rom

	.bss.align :
	{
		. = ALIGN(4);
		_bss = .;
	} >ram AT>rom

  .bss.start :
	{
		_bss_lma = LOADADDR(.bss.start);
	} >ram AT>rom

  .bss :
	{
		*(.sbss*)
		*(.gnu.linkonce.sb.*)
		*(.bss .bss.*)
		*(.gnu.linkonce.b.*)
		*(COMMON)

		. = ALIGN(4);
		_ebss = .;
	} >ram AT>rom


	. = ALIGN(8);
	_end = .;

  .stack :
	{
		. = ALIGN(16);
		. += __stack_size;
		_stack_top = .;
	} >ram AT>ram

}
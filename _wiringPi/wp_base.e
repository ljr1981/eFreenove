note
	description: "Representation of Wrapped WiringPi C Functions."
	ca_ignore: "CA088" -- Mergeable feature clauses for Status Report is actually not true.

class
	WP_BASE

inherit
	ANY
		redefine
			default_create
		end

	WP_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--<Precursor>
			-- Initialize with `wiringPiSetup'.
		require else
			not_initialized: not is_wiringpi_initialized
		do
			Precursor
			initialize_wiringpi
		ensure then
			is_initialized: is_wiringpi_initialized
		end

feature -- Status Report

	is_wiringpi_initialized: BOOLEAN
			-- Has the `wiringPiSetup' been called?

feature -- Basic Operations

	initialize_wiringpi
			-- Initialize `wiringPiSetup'.
		require
			not_initialized: not is_wiringpi_initialized
		do
			wiringPiSetup
			is_wiringpi_initialized := True
		ensure
			setup: is_wiringpi_initialized
		end

feature {NONE} -- WiringPi Setup

	wiringPiSetup
			-- `wiringPiSetup'
		require
			not_initialized: not is_wiringpi_initialized
		external
			"C signature use <wiringPi.h>"
		alias
			"wiringPiSetup"
		end

feature -- WiringPi Wraps

	pinMode (a_wpi_pin_number, a_pin_mode:INTEGER)
			-- Set `pinMode' to `a_wpi_pin_number' with `a_pin_mode'
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_mode: is_valid_pin_mode (a_pin_mode)
		external
			"C inline use <wiringPi.h>"
		alias
			"pinMode($a_wpi_pin_number, $a_pin_mode)"
		end

	digitalWrite (a_wpi_pin_number, a_hi_lo: INTEGER)
			-- Write `a_hi_lo' (digital 1 or 0) to `a_wpi_pin_number'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_hi_lo: is_valid_hi_lo (a_hi_lo)
		external
			"C inline use <wiringPi.h>"
		alias
			"digitalWrite($a_wpi_pin_number, $a_hi_lo)"
		end

	digitalRead (a_wpi_pin_number: INTEGER): INTEGER
			-- Read hi-lo value of `a_wpi_pin_number'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
		external
			"C inline use <wiringPi.h>"
		alias
			"return digitalRead($a_wpi_pin_number)"
		end

	pullUpDnControl (a_wpi_pin_number, a_pull_up_down_off: INTEGER)
			-- Set `pullUpDnControl' on `a_wpi_pin_number' for `a_pull_up_down_off'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_pud: is_valid_pud (a_pull_up_down_off)
		external
			"C inline use <wiringPi.h>"
		alias
			"pullUpDnControl($a_wpi_pin_number, $a_pull_up_down_off)"
		end

	softPwmCreate (a_wpi_pin_number, a_low, a_high: INTEGER)
			-- Create a software-based PWM for `a_wpi_pin_number' between `a_low' and `a_high' value.
		note
			EIS: "name=PWM", "src=https://en.wikipedia.org/wiki/Pulse-width_modulation"
			define_pwm: "[
				PWM = Pulse-width Modulation. See EIS.
						PWM turns on a switch to allow current to flow for
						some percentage of a 'duty-cycle' (period of time).
						If the percent = 100%, then full-power is the result
						because the switch is on 100% of the time of the
						'duty-cycle'. If the percent is 75%, then only 75%
						of full-power (i.e. 5V is realized at 3.75V). By
						stepping through 0-100 and then 100-0%, we can
						effectively create a sine-wave, mimicking an analog
						signal digitally. Imagine an LED raising and lowering
						in brightness as it follows the power-output of the
						PWM duty-cycle.
				]"
		require
			valid_setup: is_wiringpi_initialized
		external
			"C inline use <softPwm.h>"
		alias
			"softPwmCreate($a_wpi_pin_number, $a_low, $a_high)"
		end

	softPwmWrite (a_wpi_pin_number, a_duty_cycle: INTEGER)
			-- Write `a_duty_cycle' (0-100%) to `a_wpi_pin_number'.
		note
			define_pwm: "See `softPwmCreate' EIS notes and definitions."
		require
			valid_setup: is_wiringpi_initialized
		external
			"C inline use <softPwm.h>"
		alias
			"softPwmWrite($a_wpi_pin_number, $a_duty_cycle)"
		end

	softPwmStop (a_wpi_pin_number: INTEGER)
			-- Stop the PWM on `a_wpi_pin_number'.
		note
			define_pwm: "See `softPwmCreate' EIS notes and definitions."
		external
			"C inline use <softPwm.h>"
		alias
			"softPwmStop($a_wpi_pin_number)"
		end

feature -- Status Report

	is_valid_wpi_pin_number (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid wiringPi pin number?
		note
			EIS: "name=wiringPi_pins",
					"src=http://wiringpi.com/pins/special-pin-functions/"
		do
			Result := (0 |..| 20).has (a_value)
		end

	is_valid_pin_mode (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid "pin mode"?
		note
			wiringpi_header_detail: "[
			// Pin modes

			#define	INPUT			 	0
			#define	OUTPUT			 	1
			#define	PWM_OUTPUT		 	2
			#define	GPIO_CLOCK		 	3
			#define	SOFT_PWM_OUTPUT		4
			#define	SOFT_TONE_OUTPUT	5
			#define	PWM_TONE_OUTPUT		6
			
			See wiringPi.h file, starting in line #56
			]"
		do
			Result := pin_modes.has (a_value)
		end

	is_valid_hi_lo (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid HIGH or LOW?
		do
			Result := (<<LOW_const, HIGH_const>>).has (a_value)
		end

	is_valid_pud (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid OFF, UP, DOWN?
			-- PUD = Pull Up/Down.
		do
			Result := (<<PUD_OFF_const, PUD_UP_const, PUD_DOWN_const>>).has (a_value)
		end

note
	analysis_notes: "[
		Take note of the "Analyze" tool in the Eiffel Studio toolbar.
		This tool is a code analyzer, which works very well. However,
		it does tend to get a little strict, so we use "ca_ignore" note
		clauses (see top of class) to turn off analysis assertions
		on a class-by-class basis. I tend to leave comments on each
		"ignore" so that the reader is not left to wonder why.
		]"

	wiringpi_symbol_table: "[
objdump -T /usr/lib/libwiringPi.so

/usr/lib/libwiringPi.so:     file format elf32-littlearm

DYNAMIC SYMBOL TABLE:
000024c8 l    d  .init	00000000              .init
0001c27c l    d  .data	00000000              .data
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_mutex_unlock
00000000      DF *UND*	00000000  GLIBC_2.4   calloc
00000000      DF *UND*	00000000  GLIBC_2.4   strstr
00000000      DF *UND*	00000000  GLIBC_2.4   raise
00000000      DF *UND*	00000000  GLIBC_2.4   cfmakeraw
00000000      DF *UND*	00000000  GLIBC_2.4   strcmp
00000000  w   DF *UND*	00000000  GLIBC_2.4   __cxa_finalize
00000000      DF *UND*	00000000  GLIBC_2.4   strtol
00000000  w   D  *UND*	00000000              _ITM_deregisterTMCloneTable
00000000      DF *UND*	00000000  GLIBC_2.4   setsockopt
00000000      DF *UND*	00000000  GLIBC_2.4   printf
00000000      DF *UND*	00000000  GLIBC_2.4   fopen
00000000      DF *UND*	00000000  GLIBC_2.4   read
00000000      DF *UND*	00000000  GLIBC_2.4   tcflush
00000000      DF *UND*	00000000  GLIBC_2.4   free
00000000      DF *UND*	00000000  GLIBC_2.4   fgets
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_mutex_lock
00000000      DF *UND*	00000000  GLIBC_2.4   nanosleep
00000000      DF *UND*	00000000  GLIBC_2.4   inet_pton
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_self
00000000      DF *UND*	00000000  GLIBC_2.4   shm_open
00000000      DF *UND*	00000000  GLIBC_2.4   time
00000000      DF *UND*	00000000  GLIBC_2.4   lseek
00000000      DF *UND*	00000000  GLIBC_2.4   pow
00000000      DF *UND*	00000000  GLIBC_2.4   rewind
00000000      DF *UND*	00000000  GLIBC_2.4   wait
00000000      DF *UND*	00000000  GLIBC_2.4   poll
00000000      DF *UND*	00000000  GLIBC_2.4   cfsetospeed
00000000      DO *UND*	00000000  GLIBC_2.4   stderr
00000000      DF *UND*	00000000  GLIBC_2.4   fwrite
00000000      DF *UND*	00000000  GLIBC_2.4   ioctl
00000000      DF *UND*	00000000  GLIBC_2.4   usleep
00000000      DF *UND*	00000000  GLIBC_2.4   tcsetattr
00000000      DF *UND*	00000000  GLIBC_2.4   gettimeofday
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_create
00000000      DF *UND*	00000000  GLIBC_2.4   sched_get_priority_max
00000000      DF *UND*	00000000  GLIBC_2.4   getenv
00000000      DF *UND*	00000000  GLIBC_2.4   puts
00000000      DF *UND*	00000000  GLIBC_2.4   malloc
00000000      DF *UND*	00000000  GLIBC_2.4   strerror
00000000  w   D  *UND*	00000000              __gmon_start__
00000000      DF *UND*	00000000  GLIBC_2.4   open
00000000      DF *UND*	00000000  GLIBC_2.4   __ctype_b_loc
00000000      DF *UND*	00000000  GLIBC_2.4   exit
00000000      DF *UND*	00000000  GLIBC_2.4   strlen
00000000      DF *UND*	00000000  GLIBC_2.4   mmap
00000000      DF *UND*	00000000  GLIBC_2.4   fprintf
00000000      DF *UND*	00000000  GLIBC_2.4   cfsetispeed
00000000      DF *UND*	00000000  GLIBC_2.4   __errno_location
00000000      DF *UND*	00000000  GLIBC_2.4   snprintf
00000000      DF *UND*	00000000  GLIBC_2.28  fcntl
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_cancel
00000000      DF *UND*	00000000  GLIBC_2.4   write
00000000      DF *UND*	00000000  GLIBC_2.4   rint
00000000      DF *UND*	00000000  GLIBC_2.4   access
00000000      DF *UND*	00000000  GLIBC_2.4   ftruncate
00000000      DF *UND*	00000000  GLIBC_2.4   fclose
00000000      DF *UND*	00000000  GLIBC_2.4   fork
00000000      DF *UND*	00000000  GLIBC_2.4   execl
00000000      DF *UND*	00000000  GLIBC_2.4   crypt
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_join
00000000      DF *UND*	00000000  GLIBC_2.4   sprintf
00000000      DF *UND*	00000000  GLIBC_2.4   vsnprintf
00000000      DF *UND*	00000000  GLIBC_2.4   getaddrinfo
00000000      DF *UND*	00000000  GLIBC_2.4   pthread_setschedparam
00000000      DF *UND*	00000000  GLIBC_2.4   socket
00000000      DF *UND*	00000000  GLIBC_2.4   clock_gettime
00000000  w   D  *UND*	00000000              _ITM_registerTMCloneTable
00000000      DF *UND*	00000000  GLIBC_2.4   fputs
00000000      DF *UND*	00000000  GLIBC_2.4   strncmp
00000000      DF *UND*	00000000  GLIBC_2.4   recv
00000000      DF *UND*	00000000  GLIBC_2.4   close
00000000      DF *UND*	00000000  GLIBC_2.4   send
00000000      DF *UND*	00000000  GLIBC_2.4   connect
00000000      DF *UND*	00000000  GLIBC_2.4   sched_setscheduler
00000000      DF *UND*	00000000  GLIBC_2.4   tcgetattr
000050d4 g    DF .text	00000058  Base        micros
00005cf4 g    DF .text	0000009c  Base        shiftIn
00007850 g    DF .text	00000114  Base        myAnalogRead
00005eac g    DF .text	00000018  Base        piUnlock
000061d8 g    DF .text	0000003c  Base        wiringPiI2CWriteReg8
00003b98 g    DF .text	00000130  Base        gpioClockSet
0000a978 g    DO .rodata	00000020  Base        piMemorySize
00006520 g    DF .text	00000058  Base        softPwmStop
00006e90 g    DF .text	000000f0  Base        mcp23s08Setup
00003cc8 g    DF .text	00000050  Base        wiringPiFindNode
0001d8a4 g    DO .bss	00000004  Base        _wiringPiTimerIrqRaw
0000512c g    DF .text	00000014  Base        wiringPiVersion
0001d8a8 g    DO .bss	00000004  Base        _wiringPiClk
000071e4 g    DF .text	00000130  Base        mcp23s17Setup
00005e20 g    DF .text	00000050  Base        piHiPri
00005bfc g    DF .text	00000004  Base        serialClose
000087d8 g    DF .text	000000b4  Base        ds18b20Setup
00005c20 g    DF .text	00000028  Base        serialPuts
00009200 g    DF .text	00000154  Base        _drcSetupNet
00006bf4 g    DF .text	000000a0  Base        mcp23017Setup
000042b4 g    DF .text	000000bc  Base        digitalWriteByte
0000662c g    DF .text	0000002c  Base        softToneWrite
00005e70 g    DF .text	00000024  Base        piThreadCreate
0000a2e4 g    DF .text	00000184  Base        loadWPiExtension
00002e2c g    DF .text	0000009c  Base        wiringPiFailure
000039fc g    DF .text	0000001c  Base        physPinToGpio
000075d0 g    DF .text	00000054  Base        pcf8591Setup
0000448c g    DF .text	00000068  Base        digitalReadByte2
0000460c g    DF .text	00000054  Base        delay
00008458 g    DF .text	00000008  Base        checksum
00004264 g    DF .text	00000024  Base        analogRead
00005ca4 g    DF .text	00000028  Base        serialDataAvail
0001c78c g    DO .data	00000040  Base        piMakerNames
00006658 g    DF .text	000000c0  Base        softToneCreate
0001d8b8 g    DO .bss	0000000c  Base        comDat
00004414 g    DF .text	00000078  Base        digitalWriteByte2
00009468 g    DF .text	000000b0  Base        pseudoPinsSetup
00007964 g    DF .text	00000068  Base        mcp3422Setup
00003e70 g    DF .text	000000b8  Base        pinModeAlt
0001d8ac g    DO .bss	00000004  Base        _wiringPiTimer
00004b30 g    DF .text	00000054  Base        pwmSetRange
00006250 g    DF .text	00000088  Base        wiringPiI2CSetupInterface
00004a1c g    DF .text	000000a8  Base        delayMicrosecondsHard
00007dc4 g    DF .text	00000078  Base        ads1115Setup
000062d8 g    DF .text	00000044  Base        wiringPiI2CSetup
00005edc g    DF .text	00000068  Base        wiringPiSPIDataRW
00005d90 g    DF .text	00000090  Base        shiftOut
00005860 g    DF .text	00000394  Base        serialOpen
0000611c g    DF .text	00000044  Base        wiringPiI2CReadReg8
00007e70 g    DF .text	00000094  Base        sn3218Setup
00005ccc g    DF .text	00000028  Base        serialGetchar
000081ac g    DF .text	0000002c  Base        read16
00006718 g    DF .text	00000050  Base        softToneStop
0001d8b4 g    DO .bss	00000004  Base        cTemp
00004d04 g    DF .text	00000268  Base        pinMode
0000862c g    DF .text	00000090  Base        htu21dSetup
00005f44 g    DF .text	00000194  Base        wiringPiSPISetupMode
00006868 g    DF .text	00000094  Base        mcp23008Setup
0001c7cc g    DO .data	00000040  Base        piRevisionNames
0001d89c g    DO .bss	00000004  Base        _wiringPiGpio
00003268 g    DF .text	00000778  Base        piBoardId
000063d8 g    DF .text	00000044  Base        softPwmWrite
00003abc g    DF .text	00000094  Base        getAlt
00007810 g    DF .text	00000040  Base        waitForConversion
0000767c g    DF .text	00000054  Base        mcp3002Setup
00008d48 g    DF .text	00000124  Base        drcSetupSerial
00003d18 g    DF .text	00000158  Base        wiringPiNewNode
0001ca9c g    DO .bss	00000004  Base        wiringPiNodes
00005bf4 g    DF .text	00000008  Base        serialFlush
000069fc g    DF .text	000000a4  Base        mcp23016Setup
0001ca90 g    DO .bss	00000004  Base        wiringPiTryGpioMem
00005628 g    DF .text	0000005c  Base        wiringPiSetupGpio
00002ec8 g    DF .text	0000039c  Base        piGpioLayout
000044f4 g    DF .text	000000c4  Base        waitForInterrupt
0000404c g    DF .text	00000134  Base        digitalWrite
00005684 g    DF .text	0000005c  Base        wiringPiSetupPhys
00007b28 g    DF .text	00000054  Base        max31855Setup
00003b50 g    DF .text	00000048  Base        pwmSetMode
00004370 g    DF .text	000000a4  Base        digitalReadByte
00004288 g    DF .text	0000002c  Base        analogWrite
00003264 g    DF .text	00000004  Base        piBoardRev
0001d8b0 g    DO .bss	00000004  Base        cPress
00008b54 g    DF .text	0000003c  Base        rht03Setup
0001ca98 g    DO .bss	00000004  Base        wiringPiDebug
000061a4 g    DF .text	00000034  Base        wiringPiI2CWrite
000056e0 g    DF .text	00000180  Base        wiringPiSetupSys
000081d8 g    DF .text	0000027c  Base        bmp180Setup
00005140 g    DF .text	000004e8  Base        wiringPiSetup
00004180 g    DF .text	000000e4  Base        pwmWrite
000074fc g    DF .text	00000074  Base        pcf8574Setup
000060d8 g    DF .text	00000008  Base        wiringPiSPISetup
00006214 g    DF .text	0000003c  Base        wiringPiI2CWriteReg16
0001ca94 g    DO .bss	00000004  Base        wiringPiReturnCodes
00005ec4 g    DF .text	00000018  Base        wiringPiSPIGetFd
00005c48 g    DF .text	0000005c  Base        serialPrintf
00003a18 g    DF .text	000000a4  Base        setPadDrive
00009354 g    DF .text	000000ec  Base        drcSetupNet
0001c80c g    DO .data	00000050  Base        piModelNames
00004bec g    DF .text	00000118  Base        pwmSetClock
000039e0 g    DF .text	0000001c  Base        wpiPinToGpio
0001d898 g    DO .bss	00000004  Base        _wiringPiPads
000077bc g    DF .text	00000054  Base        mcp4802Setup
00004f6c g    DF .text	00000114  Base        pullUpDnControl
00007724 g    DF .text	00000054  Base        mcp3004Setup
0001d8a0 g    DO .bss	00000004  Base        _wiringPiPwm
00005c00 g    DF .text	00000020  Base        serialPutchar
00004b84 g    DF .text	00000068  Base        pwmToneWrite
00003f28 g    DF .text	00000124  Base        digitalRead
00006160 g    DF .text	00000044  Base        wiringPiI2CReadReg16
0000641c g    DF .text	00000104  Base        softPwmCreate
000060e0 g    DF .text	0000003c  Base        wiringPiI2CRead
00004ac4 g    DF .text	0000006c  Base        delayMicroseconds
00005080 g    DF .text	00000054  Base        millis
00007bc0 g    DF .text	00000074  Base        max5322Setup
000073c4 g    DF .text	00000088  Base        sr595Setup
00004660 g    DF .text	000003bc  Base        wiringPiISR
00005e94 g    DF .text	00000018  Base        piLock

]"

end

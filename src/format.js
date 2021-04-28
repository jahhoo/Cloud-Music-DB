const format = (number) => {
	const minutes = Math.floor(number / 60);
	const secs = Math.floor(number % 60);
	
	return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

export default format;